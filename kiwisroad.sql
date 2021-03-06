-- *******************************************************
-- 	Implementacion con Tecnologia Objeto-Relacional
-- 	Rutas Turisticas Urbanas (RTU)

-- 	Autores: 
-- 		Carla Urrea 09-11215
-- 		Oriana Gomez 09-10336
-- 		Mary Ontiveros 08-10813

-- 	Fecha de ultima modifiacion: 15/12/2013

-- 	SUBCONJUNTO DE KIWI'S ROAD

-- 	Clases: 
-- 		COORDENADA GEOGRAFICA
-- 			PARADA
-- 				HITO
-- 				SERVICIO
-- 		ACTIVIDAD
-- 		RUTA TURISTICA
-- 		VIA
-- 		EVENTO
-- 		USUARIO 
-- 			GUIAc
	
-- 	Asociaciones
-- 		tiene (Hito - Act)
-- 		formadaPor (Hito - Ruta)
-- 		seEncuentra (Parada - Coord)
-- 		seDivide (Via - Ruta)
-- 		conjuntoDe (Coord - Ruta)
-- 		crea (Usuario - Ruta)
-- 		elige (Usuario - Ruta)
-- 		organiza (Guia - Evento - Ruta)

-- 	Agregaciones:
-- 		Coordenada Geografica es parte de Via
-- 		Via es parte de Ruta Turistica
-- 		Hito es parte de Ruta Turistica
-- *******************************************************

-- Listar todos los tipos en sqlplus
-- 	select object_name from user_objects where object_type = 'TYPE';
-- Listar tablas
-- 	select object_name from user_objects where object_type = 'TABLE'; 
-- Listar errores
-- 	select * from user_errors;


-- *******Creacion de tipos para los atributos multivaluados******
--Los atributos multivaluados tendran como nombre:
--	tipo_nombdreDelTipo

-- y seran representados como VARRAY o tablas de referencia hacia otros tipos

CREATE OR REPLACE TYPE tipo_ambiente_via_act3 AS VARRAY(4) OF VARCHAR(20);
/

CREATE OR REPLACE TYPE tipo_categoria_estado4 AS VARRAY(4) OF VARCHAR(20);
/

CREATE OR REPLACE TYPE tipo_servicio AS VARRAY(5) OF VARCHAR(20);
/

CREATE OR REPLACE TYPE tipo_etiqueta AS VARRAY(6) OF VARCHAR(20);
/


CREATE OR REPLACE TYPE IMAGEN_T AS OBJECT (
	tituloImagen VARCHAR(50),
	imagen BLOB --preguntar si esto va aqui o en la tabla, quizas??
);
/

-- Tipo Multivaluado para Imagenes
CREATE OR REPLACE TYPE tipo_imagen AS TABLE OF REF IMAGEN_T;
/

-- Tipo multivaluado para fechas y horas 
CREATE OR REPLACE TYPE tipo_fecha_hora AS TABLE OF DATE;
/

--*********** Creacion de las clases utilizadas en Kiwi's Road ***********



CREATE OR REPLACE TYPE COORDENADA_T AS OBJECT (
	latitud NUMBER, --define un numero cuya parte entera sera maximo de 8
	longitud NUMBER, --digitos y parte decimal de 8 digitos*/
	altitud NUMBER
);
/

--Tipo referencia a tabla de referencias de coordenadas
CREATE OR REPLACE TYPE REF_COORDENADAS_T AS TABLE OF REF COORDENADA_T;
/

CREATE OR REPLACE TYPE PARADA_T AS OBJECT (
	idParada INTEGER,
	nombreParada VARCHAR(30),
	tipo VARCHAR(20), --puede ser HITO o SERVICIO
	refCoordenada REF COORDENADA_T 
	-- como la asociacion es 1,1 - 0,1 entonces para cada parada, solo existe una coordenada
	-- que la represente
)NOT FINAL;
/


CREATE OR REPLACE TYPE HITO_T UNDER PARADA_T (
	categoriaHito tipo_categoria_estado4,
	datosInteres VARCHAR(100),
	imagenes tipo_imagen,
	curiosidades VARCHAR(100),
	estado tipo_categoria_estado4, 
	horario VARCHAR(20)
);
/

--Tipo referencia a tabla de referencias de hitos
CREATE OR REPLACE TYPE REF_HITOS_T AS TABLE OF REF HITO_T;
/

CREATE OR REPLACE TYPE SERVICIO_T UNDER PARADA_T (
	tipoServicio tipo_servicio,
	descripcionS VARCHAR(100),
	horarioAtencion VARCHAR(100)
);
/

CREATE OR REPLACE TYPE VIA_T AS OBJECT (
	idVia INTEGER,
	nombreVia VARCHAR(50),
	tipoVia VARCHAR(20),  
	distanciaVia INTEGER,
	refCoordenadasVia REF_COORDENADAS_T
);
/

-- Tipo referencia a tabla de referencias de vias 
CREATE OR REPLACE TYPE REF_VIAS_T AS TABLE OF REF VIA_T;
/


CREATE OR REPLACE TYPE ACTIVIDAD_T AS OBJECT (
	nombreAct VARCHAR(50),
	costoAct FLOAT(5),
	tipoAct tipo_ambiente_via_act3, 
	ambienteAct tipo_ambiente_via_act3,
	fechaAct DATE,
	refHitoAct REF HITO_T
);
/

-- Tipo referencia a tabla de referencias de vias 
CREATE OR REPLACE TYPE REF_ACTIVIDADES_T AS TABLE OF REF ACTIVIDAD_T;
/


CREATE OR REPLACE TYPE EVENTO_T AS OBJECT (
	nombreEvento VARCHAR(50),
	descripcionEvento VARCHAR (100),
	ocurrencia VARCHAR(20),
	fotos tipo_imagen,
	etiquetas tipo_etiqueta
);
/


CREATE OR REPLACE TYPE RUTA_T AS OBJECT (
	nroRuta INTEGER,
    etiquetas tipo_etiqueta,
    distanciaARecorrer INTEGER,
    horaSalida DATE,
    recomendaciones INTEGER,
    calificacion INTEGER,
    tips VARCHAR(100), 
    tiempoAprox VARCHAR(50),
    fechaCrea DATE, -- Atributo absorbido de la asociacion crea  
	refViasRuta REF_VIAS_T,
	refHitosRuta REF_HITOS_T,
	--MEMBER FUNCTION calcularCalificacion RETURN INTEGER,
	MEMBER FUNCTION calcularDistanciaARecorrer(id INTEGER) RETURN INTEGER,
	--MEMBER FUNCTION calcularTiempoAprox RETURN INTEGER
	MEMBER PROCEDURE listarActividadesDeRuta(id INTEGER)
);
/

-- Tipo referencia a tabla de referencias de rutas
CREATE OR REPLACE TYPE REF_RUTAS_T AS TABLE OF REF RUTA_T;
/


CREATE OR REPLACE TYPE USUARIO_T AS OBJECT(
	nombreUsuario VARCHAR(50),
	correo VARCHAR(50),
	contrasena VARCHAR(6),
	visitante INTEGER
)NOT FINAL;
/


CREATE OR REPLACE TYPE GUIA_T UNDER USUARIO_T (
	curriculum CLOB
);
/


CREATE OR REPLACE TYPE ELIGE_T AS OBJECT (
	cantPersonas INTEGER,
	rutaElige_ref REF RUTA_T,
	usuarioElige_ref REF USUARIO_T
);
/


CREATE OR REPLACE TYPE ORGANIZA_T AS OBJECT (
	eventoOrganiza_ref REF EVENTO_T,
	usuarioOrganiza_ref REF GUIA_T,
	rutaOrganiza_ref REF RUTA_T
);
/


ALTER TYPE COORDENADA_T ADD ATTRIBUTE refViasCoord REF_VIAS_T CASCADE;
ALTER TYPE HITO_T ADD ATTRIBUTE refRutasHito REF_RUTAS_T CASCADE;
ALTER TYPE VIA_T ADD ATTRIBUTE refRutasVia REF_RUTAS_T CASCADE;

ALTER TYPE PARADA_T ADD ATTRIBUTE refHitosAct REF_ACTIVIDADES_T CASCADE;

--funcion que representa la asociacion califica tiene
ALTER TYPE HITO_T ADD MEMBER FUNCTION obtenerActividades RETURN REF_ACTIVIDADES_T CASCADE,
-- funcion que permite la agregacion formadaPor y devuelve las rutas a las que pertenece el hito
ALTER TYPE HITO_T ADD MEMBER FUNCTION formaParteDe RETURN REF_RUTAS_T CASCADE


--************ Creacion de Tablas utilizadas en Kiwi's Road ***********


CREATE TABLE COORDENADA_GEOGRAFICA OF COORDENADA_T (
	latitud NOT NULL, --define un numero cuya parte entera sera maximo de 8*/
	longitud NOT NULL, --digitos y parte decimal de 8 digitos*/
	altitud NOT NULL, 
	PRIMARY KEY (latitud, longitud, altitud)
) NESTED TABLE refViasCoord STORE AS refViasCoordTable;


CREATE TABLE VIA OF VIA_T (
	idVia NOT NULL,
	PRIMARY KEY (idVia),
	nombreVia NOT NULL,
	tipoVia NOT NULL, 
	distanciaVia NOT NULL
) NESTED TABLE refRutasVia STORE AS refRutasViaTable, 
  NESTED TABLE refCoordenadasVia STORE AS refCoordenadasViaTable;


CREATE TABLE PARADA OF PARADA_T (
	idParada NOT NULL,
	PRIMARY KEY (idParada),
	nombreParada NOT NULL,
	tipo NOT NULL
	--Como la generalizacion es disjunta solo se crea tabla de la superclase
	--y luego con triggers se verificara el tipo y dependiendo de ellos se hara un constructor
	--para cada uno	
) NESTED TABLE refHitosAct STORE AS tieneActividad;

CREATE TABLE ACTIVIDAD OF ACTIVIDAD_T (
	nombreAct NOT NULL,
	costoAct NOT NULL,
	tipoAct NOT NULL, 
	ambienteAct NOT NULL,
	fechaAct NOT NULL,
	refHitoAct NOT NULL,
	PRIMARY KEY(nombreAct, fechaAct)
);


CREATE TABLE USUARIO OF USUARIO_T (
	correo NOT NULL,
	PRIMARY KEY (correo)
);


CREATE TABLE GUIA OF GUIA_T(
	curriculum NOT NULL
);


CREATE TABLE RUTA OF RUTA_T(
	nroRuta NOT NULL,
	PRIMARY KEY (nroRuta),
    etiquetas NOT NULL,
    horaSalida NOT NULL,
    recomendaciones NOT NULL,
    calificacion NOT NULL,
    tips NULL, 
    tiempoAprox NULL,
    fechaCrea NULL -- Atributo absorbido de la asociacion crea  
)NESTED TABLE refViasRuta STORE AS refViasRutaTable, 
 NESTED TABLE refHitosRuta STORE AS formadaPor;


CREATE TABLE ELIGE OF ELIGE_T (	
	FOREIGN KEY (rutaElige_ref) REFERENCES RUTA, 
	FOREIGN KEY (usuarioElige_ref) REFERENCES USUARIO
);


CREATE TABLE EVENTO OF EVENTO_T (
	nombreEvento NOT NULL,
	PRIMARY KEY (nombreEvento),
	descripcionEvento NOT NULL,
	ocurrencia NOT NULL,
	etiquetas NOT NULL
)NESTED TABLE fotos STORE AS refFotosTable;


CREATE TABLE ORGANIZA OF ORGANIZA_T (
	FOREIGN KEY (rutaOrganiza_ref) REFERENCES RUTA,
	FOREIGN KEY (usuarioOrganiza_ref) REFERENCES GUIA,
 	FOREIGN KEY (eventoOrganiza_ref) REFERENCES EVENTO
);

ALTER TABLE VIA ADD	CONSTRAINT "TIPO_VIA_DOMINIO" CHECK (tipoVia IN ('aerea', 'maritima', 'terrestre'));
ALTER TABLE PARADA ADD CONSTRAINT "CHECK_TIPO_PARADA" CHECK (tipo IN ('hito', 'servicio'));
ALTER TABLE RUTA ADD CONSTRAINT "CALIFICACION_DOMINIO" CHECK (calificacion BETWEEN 1 and 5);

ALTER TYPE PARADA_T ADD MEMBER FUNCTION constructorHito RETURN REF HITO_T CASCADE;
ALTER TYPE PARADA_T ADD MEMBER FUNCTION constructorServicio RETURN REF SERVICIO_T CASCADE;			
			
----------------------------------------------------
-- Definicion e implementacion de Metodos y Triggers
----------------------------------------------------

CREATE OR REPLACE TYPE BODY RUTA_T AS 

	--1) funcion que calcula la distancia total de una ruta
	MEMBER FUNCTION calcularDistanciaARecorrer(id INTEGER) RETURN  INTEGER  IS total INTEGER;
		CURSOR distancia_vias IS
			SELECT tr.COLUMN_VALUE.distanciaVia AS distanciaVia FROM THE (SELECT r.refViasRuta FROM RUTA r WHERE r.nroRuta= id) tr;
	BEGIN 	
		total := 0;
		FOR i IN distancia_vias
		LOOP
			total := total + i.distanciaVia;	
		END LOOP;
		RETURN total;
	END;
	
	--2) procedimiento que lista las actividades de una ruta
	MEMBER PROCEDURE listarActividadesDeRuta(id INTEGER) IS act VARCHAR(50);
		CURSOR act_hitos_ruta IS
			SELECT a.COLUMN_VALUE.nombreAct AS nombreAct FROM THE (SELECT r.refHitosRuta FROM RUTA r WHERE r.nroRuta= id) tr,
				THE (SELECT p.refHitosAct FROM PARADA p) a, PARADA p
			WHERE (p.idParada = tr.COLUMN_VALUE.idParada);
	BEGIN
		FOR i IN act_hitos_ruta
		LOOP
			dbms_output.put_line('Activiad es: '|| i.nombreAct);
		END LOOP;
	END;
END;
/


-- 3) Funcion que dada una coordenada devuelve la parada que se encuentra en esta coordenada
ALTER TYPE COORDENADA_T ADD MEMBER FUNCTION ref_Coordenada_Parada RETURN PARADA_T CASCADE;

CREATE OR REPLACE TYPE BODY COORDENADA_T AS MEMBER FUNCTION ref_Coordenada_Parada RETURN PARADA_T IS 
  objetoParada PARADA_T;
  BEGIN 
    SELECT value(p) INTO objetoParada FROM PARADA p
    WHERE DEREF(p.refCoordenada).latitud = self.latitud 
      AND DEREF(p.refCoordenada).longitud = self.longitud
      AND DEREF(p.refCoordenada).altitud = self.altitud; 
    RETURN objetoParada; 
  END;
END;
/

-- Trigger que mantiene la consistencia entre la nested table de vias en la tabla RUTA 
-- y la nested table de rutas en la tabla VIA

CREATE OR REPLACE TRIGGER consistenciaRutaVia
  BEFORE INSERT OR UPDATE ON RUTA
  FOR EACH ROW
  DECLARE
    via_agregar INTEGER;
    CURSOR vias_rutas IS
      SELECT vias.COLUMN_VALUE.idVia AS idVia FROM THE (SELECT r.refViasRuta FROM RUTA r WHERE r.nroRuta = :NEW.nroRuta) vias;
  BEGIN
    FOR i IN vias_rutas
    LOOP
      SELECT idVia INTO via_agregar FROM VIA WHERE idVia = i.idVia;
      IF via_agregar IS NULL THEN 
        RAISE_APPLICATION_ERROR(-20336, 'La via especificada no existe debe agregarla a la tabla VIA');
      ELSE 
    	  INSERT INTO TABLE (SELECT v.refRutasVia FROM VIA v WHERE v.idVia = via_agregar)
          SELECT ref(r) FROM RUTA r WHERE r.nroRuta = :NEW.nroRuta; 
      	COMMIT;
      END IF;
    END LOOP;
  END;
/  

--Trigger que mantiene la consistencia entre la nested table de rutas en la tabla VIA
-- y la nested table de vias en la tabla RUTA

CREATE OR REPLACE TRIGGER consistenciaViaRuta
  BEFORE INSERT OR UPDATE ON VIA
  FOR EACH ROW
  DECLARE
    ruta_agregar INTEGER;
    CURSOR rutas_vias IS 
      SELECT rutas.COLUMN_VALUE.nroRuta AS nroRuta FROM THE (SELECT v.refRutasVia FROM VIA v WHERE v.idVia = :NEW.idVia) rutas;
  BEGIN
    IF UPDATING('refRutasVia') THEN
      FOR i IN rutas_vias
      LOOP
        SELECT nroRuta INTO ruta_agregar FROM RUTA WHERE nroRuta = i.nroRuta;
        IF ruta_agregar IS NULL THEN
          RAISE_APPLICATION_ERROR(-20813, 'La ruta formada por esta via debe existir');
        END IF;
      END LOOP;
    ELSIF INSERTING THEN
      OPEN rutas_vias;
      IF rutas_vias%FOUND THEN
        RAISE_APPLICATION_ERROR(-20215, 'Para asociar una via a una ruta debe agregar la via sin referencias y luego agregar la ruta');
      END IF;
    END IF;
  END;
/

-- Trigger que verifica que la actividad se agregue a un hito y no a un servicio en parada

CREATE OR REPLACE TRIGGER verificarTipoParada BEFORE INSERT OR UPDATE ON ACTIVIDAD
FOR EACH ROW
	DECLARE
		tipoPa VARCHAR(20);
	BEGIN
		SELECT p1.tipo INTO tipoPa 
		FROM PARADA p1
		WHERE 
			DEREF(:NEW.refHitoAct).idParada = p1.idParada
		;

		IF tipoPa <> 'hito' THEN
			RAISE_APPLICATION_ERROR(-42000, 'No puede insertarse');
		END IF;
	END;
/
