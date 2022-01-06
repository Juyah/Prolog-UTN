tarea(vigilanteDelBarrio, ingerir(pizza, 1.5, 2),laBoca).
tarea(vigilanteDelBarrio, vigilar([pizzeria, heladeria]), barracas).
tarea(canaBoton, asuntosInternos(vigilanteDelBarrio), barracas).
tarea(sargentoGarcia, vigilar([pulperia, haciendaDeLaVega, plaza]),puebloDeLosAngeles).
tarea(sargentoGarcia, ingerir(vino, 0.5, 5),puebloDeLosAngeles).
tarea(sargentoGarcia, apresar(elzorro, 100), puebloDeLosAngeles). 
tarea(vega, apresar(neneCarrizo,50),avellaneda).
tarea(jefeSupremo, vigilar([congreso,casaRosada,tribunales]),laBoca).

ubicacion(puebloDeLosAngeles).
ubicacion(avellaneda).
ubicacion(barracas).
ubicacion(marDelPlata).
ubicacion(laBoca).
ubicacion(uqbar).

jefe(jefeSupremo,vega ).
jefe(vega, vigilanteDelBarrio).
jefe(vega, canaBoton).
jefe(jefeSupremo,sargentoGarcia).

%Punto 1
frecuenta(Persona, Ubicacion):-
    tarea(Persona, _, Ubicacion).
frecuenta(Persona, buenosAires):-
    esAgente(Persona).
frecuenta(vega, quilmes).
frecuenta(Persona, marDelPlata):-
    tarea(Persona, vigilar(Lista), _),
    member(alfajoreria, Lista).

esAgente(Persona):-
    tarea(Persona, _, _).
    
%Punto 2
lugarInaccesible(Ubicacion):-
    ubicacion(Ubicacion),
    not(frecuenta(_, Ubicacion)).

%Punto 3
afincado(Persona):-
    tarea(Persona,_, Ubicacion),
    not((tarea(Persona,_, OtraUbicacion), Ubicacion \= OtraUbicacion)).

%Punto 4
cadenaDeMando([X,Y]):-
    jefe(X,Y).
cadenaDeMando([X , Y | Cola]):-
    jefe(X,Y),
    cadenaDeMando([Y | Cola]).

%Punto 5
agentePremiado(Persona):-
    esAgente(Persona),
    puntosAgente(Persona, Puntos),
    not((puntosAgente(_, OtrosPuntos), OtrosPuntos > Puntos)).

puntosAgente(Persona, PuntosTotales):-
    esAgente(Persona),
    findall(Puntos, (tarea(Persona, Tarea, _), puntosObtenidos(Tarea, Puntos)), PuntosTareas),
    sum_list(PuntosTareas, PuntosTotales).

puntosObtenidos(vigilar(Lista), Puntos):-
    length(Lista, CantidadNegocios),
    Puntos is CantidadNegocios * 5.
puntosObtenidos(ingerir(_, Tamano, Cantidad), Puntos):-
    Puntos is (-10) * Tamano * Cantidad.
puntosObtenidos(apresar(_, Recompensa), Puntos):-
    Puntos is Recompensa / 2.
puntosObtenidos(asuntosInternos(Persona), Puntos):-
    puntosAgente(Persona, PuntosPersona),
    Puntos is PuntosPersona * 2.

%Punto 6 
/* Se utilizo polimorfismo por la facilidad de crear nuevos puntajes obtenidos y nuevas tareas que se creen.
Orden superior para manejar comodamente con numeros.
Inversibilidad para poder realizar preguntas de nuestro universo cerrado y obtener una respuesta de quienes lo cumplen.
*/

%Punto 7
tarea(vega, vigilar([churreria, alfajoreria]), buenosAires).
ubicacion(buenosAires).
ubicacion(quilmes).

