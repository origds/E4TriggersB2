
INSERT INTO COORDENADA_GEOGRAFICA (latitud,longitud,altitud) VALUES ('1.0','2.0','3.0');
INSERT INTO COORDENADA_GEOGRAFICA (latitud,longitud,altitud) VALUES ('4.0','5.0','6.0');
INSERT INTO COORDENADA_GEOGRAFICA (latitud,longitud,altitud) VALUES ('7.0','8.0','9.0');



DECLARE 
	coord REF COORDENADA_T;
BEGIN
	SELECT REF(c) INTO coord
	FROM COORDENADA_GEOGRAFICA c 
	WHERE c.latitud = 1.0 AND c.longitud = 2.0 AND c.altitud = 3.0
	;
INSERT INTO PARADA VALUES (
	HITO_T(6, 'El Avila', 'hito', coord, REF_ACTIVIDADES_T(), tipo_categoria_estado4('chevere', 'epale'), 
		'datos de interes', NULL,'curiosidades asi tipo cheveres', 
		tipo_categoria_estado4('cerrado', 'hola'), 'abierto de 8 a 12',
		REF_RUTAS_T()
	)
);
END; 
/


DECLARE 
	coord REF COORDENADA_T;
BEGIN
	SELECT REF(c) INTO coord
	FROM COORDENADA_GEOGRAFICA c 
	WHERE c.latitud = 4.0 AND c.longitud = 5.0 AND c.altitud = 6.0
	;
INSERT INTO PARADA VALUES (
	HITO_T(7, 'Parque del Este', 'hito', coord, REF_ACTIVIDADES_T(), tipo_categoria_estado4('chevere', 'epale'), 
		'datos de interes', NULL,'curiosidades asi tipo cheveres', 
		tipo_categoria_estado4('cerrado', 'hola'), 'abierto de 8 a 12',
		REF_RUTAS_T()
	)
);
END; 
/


DECLARE 
	coord REF COORDENADA_T;
BEGIN
	SELECT REF(c) INTO coord
	FROM COORDENADA_GEOGRAFICA c 
	WHERE c.latitud = 7.0 AND c.longitud = 8.0 AND c.altitud = 9.0
	;
INSERT INTO PARADA VALUES (
	SERVICIO_T(8, 'Estacion Gasolina', 'servicio', coord, REF_ACTIVIDADES_T(), 		
		tipo_servicio('gasolinera'), 
		'es una bomba de gasolina grande',
		'abierto 24hrs'
	)
);
END; 
/

DECLARE 
	hito REF HITO_T;
BEGIN
	SELECT TREAT(REF(h) AS REF HITO_T) INTO hito
	FROM PARADA h 
	WHERE h.tipo = 'hito' AND
	      h.idParada = 6
	;
INSERT INTO ACTIVIDAD VALUES (
	'Actividad1',
	50.5,
	tipo_ambiente_via_act3('linda'),
	tipo_ambiente_via_act3('al aire libre'),
	to_date('11:30:00', 'hh24:mi:ss'),
	hito
);
END;
/


DECLARE 
	hito REF HITO_T;
BEGIN
	SELECT TREAT(REF(h) AS REF HITO_T) INTO hito
	FROM PARADA h 
	WHERE 
		h.tipo = 'hito' AND
		h.idParada = 7
	;
INSERT INTO ACTIVIDAD VALUES (
	'Actividad1',
	50.5,
	tipo_ambiente_via_act3('linda'),
	tipo_ambiente_via_act3('al aire libre'),
	to_date('08:30:00', 'hh24:mi:ss'),
	hito
);
END;
/


DECLARE 
	hito REF HITO_T;
BEGIN
	SELECT TREAT(REF(h) AS REF HITO_T) INTO hito
	FROM PARADA h 
	WHERE 
		h.tipo = 'hito' AND
		h.idParada = 7 
	;
INSERT INTO ACTIVIDAD VALUES (
	'Actividad2',
	50.5,
	tipo_ambiente_via_act3('linda'),
	tipo_ambiente_via_act3('al aire libre'),
	to_date('05:30:00', 'hh24:mi:ss'),
	hito
);
END;
/


INSERT INTO TABLE (SELECT r.refHitosRuta FROM RUTA r WHERE r.nroRuta = 2)
	SELECT TREAT(ref(p) AS REF HITO_T) FROM PARADA p WHERE p.idParada = 6;
COMMIT;

INSERT INTO TABLE (SELECT r.refHitosRuta FROM RUTA r WHERE r.nroRuta = 2)
	SELECT TREAT(ref(p) AS REF HITO_T) FROM PARADA p WHERE p.idParada = 7;
COMMIT;

INSERT INTO TABLE (SELECT r.refHitosRuta FROM RUTA r WHERE r.nroRuta = 2)
	SELECT TREAT(ref(p) AS REF HITO_T) FROM PARADA p WHERE p.idParada = 8;
COMMIT;


