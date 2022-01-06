%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parte 2 - La copa de las casas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).

casa(gryffindor).
casa(slytherin).
casa(ravenclaw).
casa(hufflepuff).

esMago(Mago):-
    esDe(Mago, _).

/*
1a. Saber si un mago es buen alumno, que se cumple si hizo alguna acción y ninguna de las cosas 
que hizo se considera una mala acción (que son aquellas que provocan un puntaje negativo).
*/
%Punto 1a

accion(fueraDeCama, harry, 50).
accion(tercerPiso, hermione, 75).
accion(biblioteca, hermione, 10).
accion(tercerPiso, harry, 75).
accion(bosque, harry, 50).
accion(mazmorras, draco, 0).
accionBuena(ajedrez, ron, 50).
accionBuena(salvarVida, hermione, 50).
accionBuena(ganarVoldemort, harry, 60).

hizoAlgunaAccion(Mago):-
    accion(_,Mago,_).
hizoAlgunaAccion(Mago):-
    accionBuena(_,Mago,_).

hizoMalaAccion(Mago):-
    accion(fueraDeCama,Mago,_).
hizoMalaAccion(Mago):-
    accion(tercerPiso,Mago,_).
hizoMalaAccion(Mago):-
    accion(biblioteca,Mago,_).
hizoMalaAccion(Mago):-
    accion(bosque,Mago,_).

buenAlumno(Mago):-
    hizoAlgunaAccion(Mago),
    not(hizoMalaAccion(Mago)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% fueraDeCama(50).
mala(fueraDeCama).
accionv2(Accion):- hace(Accion, _).
hace(accion(fueraDeCama, 50), harry).
hace(accion(fueraDeCama, 50), draco).
hace(accion(fueraDeCama, 50), ron).
buenAlumnov2(Alumno):-
    hace(Accion, Alumno),
    not(mala(Accion)).


/*
accionV2(fueraDeCama, harry).
mala(fueraDeCama).
hace(Accion, Mago):- 
    accionV2(Accion, Mago, _).

buenAlumnoV2(Mago):-
    accionV2(Accion),
    hace(Accion, Mago),
    not(mala(Accion)).
*/


/*
1b. Saber si una acción es recurrente, que se cumple si más de un mago hizo esa misma acción.
*/
%Punto 1b

accionRecurrente(Accion):-
    accion(Accion, Mago, _),
    accion(Accion, OtroMago,_),
    Mago \= OtroMago.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


/*
%% fueraDeCama(50).
mala(fueraDeCama).
hace(accion(fueraDeCama, 50), harry).
buenAlumnov2(Alumno):-
    hace(Accion, Alumno),
    not(mala(Accion)).
*/
accionRecurrentev2(Accion):-
    hace(Accion, Mago1),
    hace(Accion, Mago2),
    Mago1 \= Mago2.
    
/*
2. Saber cuál es el puntaje total de una casa, que es la suma de los puntos obtenidos por sus miembros.
*/
%Punto 2
puntosMago(Mago, Puntos):-
    esMago(Mago),
    puntosMagoNegativo(Mago, Negativo),
    puntosMagoPositivo(Mago, Positivo),
    puntosPregunta(Mago, Positivo2),
    Puntos is Positivo + Positivo2 - Negativo.

puntosMagoNegativo(Mago, Puntos):-
    findall(Punto, accion(_,Mago,Punto),PuntosLista),
    sum_list(PuntosLista, Puntos).

puntosMagoPositivo(Mago, Puntos):-
    findall(Punto, accionBuena(_,Mago,Punto),PuntosLista),
    sum_list(PuntosLista, Puntos).

puntajeCasa(Casa, Puntos):-
    casa(Casa),
    findall(Punto,(esDe(Mago,Casa),puntosMago(Mago,Punto)),PuntosLista),
    sum_list(PuntosLista, Puntos).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% hace(accion(fueraDeCama, 50), harry).
% esDe(draco, slytherin).

% puntos(Mago)
% hace(accion(_, Puntos), Mago)
/*
puntos(Accion, Mago, PuntosPorAccion):-
    hace( accion(Accion, Puntos), Mago),
    mala(Accion),
    PuntosPorAccion is Puntos*(-1).
*/

mago(Mago):- esDe(Mago,_).

puntajev2(Casa, PuntosTotales):-
    casa(Casa), mago(Mago),
    findall(Puntos, (esDe(Mago, Casa) ,hace(accion(_, Puntos), Mago) ) , PuntosMagos),
    sum_list(PuntosMagos, PuntosTotales). 
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
3. Saber cuál es la casa ganadora de la copa, que se verifica para aquella casa que haya obtenido unacantidad mayor de puntos que todas las otras.
*/
%Punto 3
casaGanadora(Casa):-
    puntajeCasa(Casa, Puntos),
    forall((puntajeCasa(OtraCasa, OtroPuntos), Casa \= OtraCasa), Puntos > OtroPuntos).

/*
4. Queremos agregar la posibilidad de ganar puntos por responder preguntas en clase. 
La información quenos interesa de las respuestas en clase son: cuál fue la pregunta, cuál es la dificultad de la pregunta y quéprofesor la hizo.
Por ejemplo, sabemos que Hermione respondió a la pregunta de dónde se encuentra un Bezoar, dedificultad 20, realizada por el profesor Snape, 
y cómo hacer levitar una pluma, de dificultad 25, realizadapor el profesor Flitwick.

Modificar lo que sea necesario para que este agregado funcione con lo desarrollado hasta ahora, teniendo en cuenta que los puntos que se otorgan 
equivalen a la dificultad de la pregunta, a menos que la hayahecho Snape, que da la mitad de puntos en relación a la dificultad de la pregunta.
*/

respuesta(harry, pregunta("Testing", 45, snape)).
respuesta(harry, pregunta("Testing", 15, silin)).
respuesta(harry, pregunta("Testing", 25, silin)).
respuesta(draco, pregunta("Testing", 30, snape)).
respuesta(ron, pregunta("Testing", 60, silin)).
respuesta(ron, pregunta("Testing", 10, silin)).
respuesta(hermione, pregunta("Testing", 15, silin)).
respuesta(hermione, pregunta("Testing", 25, snape)).
respuesta(luna, pregunta("Testing", 35, silin)).
respuesta(luna, pregunta("Testing", 80, silin)).

respondio(Mago, pregunta(Pregunta, Dificultad, Profesor)):-
    esMago(Mago),
    respuesta(Mago, pregunta(Pregunta,Dificultad, Profesor)),
    Profesor \= snape.

puntosPregunta(Mago, Puntos):-
    preguntaNoSnape(Mago,PuntoNoSnape),
    preguntaSnape(Mago,PuntoSnape),
    Puntos is PuntoNoSnape + PuntoSnape.

preguntaNoSnape(Mago, Puntos):-
    esMago(Mago),
    findall(Punto,(respuesta(Mago,pregunta(_,Punto,Profesor)),Profesor \= snape),PuntosLista),
    sum_list(PuntosLista,Puntos).

preguntaSnape(Mago, Puntos):-
    esMago(Mago),
    findall(Punto,respuesta(Mago,pregunta(_,Punto,snape)), PuntosLista),
    sum_list(PuntosLista,PuntosLimpios),
    Puntos is PuntosLimpios / 2.
    