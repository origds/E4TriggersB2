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
-- 			GUIA
	
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
	-- MEMBER FUNCTION ref_Coordenada_Parada RETURN REF PARADA_T
);
/

--Buscar en google la sintaxis correcta
-- ALTER TYPE ADD BODY STATEMENT 
-- 	CREATE FUNCTION ref_Coordenada_Parada() 
--    	RETURN REF PARADA_T is refParada;
--    BEGIN 
--       SELECT * FROM PARADA AS p
--       WHERE p.refCoordenada = self; 
--       RETURN(p.refCoordenada); 
--     END;

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
	MEMBER FUNCTION calcularDistanciaARecorrer RETURN INTEGER,
	--MEMBER FUNCTION calcularTiempoAprox RETURN INTEGER
	MEMBER PROCEDURE listarActividadesDeRuta
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

ALTER TYPE HITO_T ADD MEMBER FUNCTION obtenerActividades RETURN REF_ACTIVIDADES_T, --funcion que representa la asociacion califica tiene
ALTER TYPE HITO_T ADD MEMBER FUNCTION formaParteDe RETURN REF_RUTAS_T -- funcion que permite la agregacion formadaPor 
													 				  -- y devuelve las rutas a las que pertenece el hito





-- CREATE OR REPLACE TRIGGER 



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
) NESTED TABLE refRutasVia STORE AS refRutasViaTable, NESTED TABLE refCoordenadasVia STORE AS refCoordenadasViaTable;


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

CREATE OR REPLACE TYPE BODY RUTA_T AS MEMBER FUNCTION calcularDistanciaARecorrer
RETURN  INTEGER  IS 
	total INTEGER;
	BEGIN 	
		SELECT SUM(ss.COLUMN_VALUE.distanciaVia) INTO total FROM THE ( 
			SELECT refViasRuta FROM RUTA) ss;
		RETURN total;	
	END;
END;
/
	
CREATE OR REPLACE TYPE BODY RUTA_T AS 
	MEMBER PROCEDURE listarActividadesDeRuta IS 
	act VARCHAR(50);
	BEGIN
		SELECT a.COLUMN_VALUE.nombreAct INTO act FROM THE (SELECT refHitosRuta FROM RUTA) h, --hitos y rutas de formadaPor
											THE (SELECT refHitosAct FROM PARADA) a --hitos y actividades de tiene
		WHERE 
			a.COLUMN_VALUE.refHitoAct.idParada = h.COLUMN_VALUE.idParada
		;
		dbms_output.put_line('Activiad es: '|| act);
	END;
END;
/

-- CREATE OR REPLACE TRIGGER verificarTipoParada  BEFORE INSERT ON ACTIVIDAD 
-- 	id INTEGER;
-- 	nombre VARCHAR(50);
-- 	BEGIN
-- 		SELECT a.COLUMN_VALUE.nombreAct INTO nombre FROM THE (SELECT refHitoAct FROM ACTIVIDAD) a
-- 														 THE (SELECT refHitosAct FROM PARADA) p
-- 		WHERE 
-- 			p.tipo == "hito" AND
-- 			p.idParada == a.COLUMN_VALUE.idParada
-- 		;
-- 	END;
