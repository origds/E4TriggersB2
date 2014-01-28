INSERT INTO COORDENADA_GEOGRAFICA (latitud, longitud, altitud) VALUES (
	'1.1','2.2','3.3'
);

INSERT INTO COORDENADA_GEOGRAFICA (latitud, longitud, altitud) VALUES (
	'4.4','5.5','6.6'
);

INSERT INTO COORDENADA_GEOGRAFICA (latitud, longitud, altitud) VALUES (
	'1.1','7.7','8.8'
);

INSERT INTO COORDENADA_GEOGRAFICA (latitud, longitud, altitud) VALUES (
	'2.2','9.9','4.4'
);

INSERT INTO COORDENADA_GEOGRAFICA (latitud, longitud, altitud) VALUES (
	'8.8','6.6','3.3'
);

INSERT INTO PARADA (idParada, nombreParada, tipo, refCoordenada)
	SELECT '1','Museo de los Ninos','hito', ref(c) FROM COORDENADA_GEOGRAFICA c 
	WHERE c.latitud = 1.1 AND c.longitud = 2.2 AND c.altitud = 3.3;

INSERT INTO PARADA (idParada, nombreParada, tipo, refCoordenada)
	SELECT '2','Parque del Este','hito', ref(c) FROM COORDENADA_GEOGRAFICA c 
	WHERE c.latitud = 4.4 AND c.longitud = 5.5 AND c.altitud = 6.6;

INSERT INTO PARADA (idParada, nombreParada, tipo, refCoordenada)
	SELECT '3','ES Gasolinera','servicio', ref(c) FROM COORDENADA_GEOGRAFICA c 
	WHERE c.latitud = 1.1 AND c.longitud = 7.7 AND c.altitud = 8.8;

INSERT INTO PARADA (idParada, nombreParada, tipo, refCoordenada)
	SELECT '4','Restaurant Avila Burguer','servicio', ref(c) FROM COORDENADA_GEOGRAFICA c 
	WHERE c.latitud = 2.2 AND c.longitud = 9.9 AND c.altitud = 4.4;

INSERT INTO PARADA (idParada, nombreParada, tipo, refCoordenada)
	SELECT '5','Teatro Teresa Carreno','hito', ref(c) FROM COORDENADA_GEOGRAFICA c 
	WHERE c.latitud = 8.8 AND c.longitud = 6.6 AND c.altitud = 3.3;
