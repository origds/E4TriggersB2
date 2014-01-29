-- Inserts para la tabla COORDENADA_GEOGRAFICA

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

-- Inserts para la tabla PARADA

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

-- Inserts para la tabla VIA 
-- Para disparar el trigger basta con colorcar att refRutasVia y su constructor REF_RUTAS_T()

INSERT INTO VIA (idVia, nombreVia, tipoVia, distanciaVia, refRutasVia) VALUES (
	'1', 'Autop. Fco. Fajardo', 'terrestre', '20', REF_RUTAS_T()
);

INSERT INTO VIA (idVia, nombreVia, tipoVia, distanciaVia, refRutasVia) VALUES (
	'2', 'Mar Caribe', 'maritima', '80', REF_RUTAS_T()
);

INSERT INTO VIA (idVia, nombreVia, tipoVia, distanciaVia, refRutasVia) VALUES (
	'3', 'Av. Rio de Janeiro', 'terrestre', '5', REF_RUTAS_T()
);

--INSERT INTO TABLE (SELECT v.refRutasVia FROM VIA v WHERE v.idVia = 3)
--  SELECT ref(r) FROM RUTA r WHERE r.nroRuta = 2;
--COMMIT;

INSERT INTO VIA (idVia, nombreVia, tipoVia, distanciaVia, refRutasVia) VALUES (
	'4', 'Calle La Colina', 'terrestre', '2', REF_RUTAS_T()
);

-- Inserts para la tabla RUTA


INSERT INTO RUTA (nroRuta, etiquetas, horaSalida, recomendaciones, calificacion, refViasRuta) VALUES (
  '1', tipo_etiqueta('cultural','recreativa'), to_date('09:43:00', 'hh24:mi:ss'),
  '195', '5', (SELECT REF_VIAS_T(ref(v)) FROM VIA v WHERE v.idVia = 1)
);

INSERT INTO RUTA (nroRuta, etiquetas, horaSalida, recomendaciones, calificacion, refViasRuta, refHitosRuta) VALUES (
	'2', tipo_etiqueta('recreativa'), to_date('08:30:00', 'hh24:mi:ss'), '70', '4', REF_VIAS_T(), REF_HITOS_T()
);

INSERT INTO TABLE (SELECT r.refViasRuta FROM RUTA r WHERE r.nroRuta = 2)
	SELECT ref(v) FROM VIA v WHERE v.idVia = 2;
COMMIT;

INSERT INTO TABLE (SELECT r.refViasRuta FROM RUTA r WHERE r.nroRuta = 2)
	SELECT ref(v) FROM VIA v WHERE v.idVia = 4;
COMMIT;
