cree(gabriel, campanita).
cree(gabriel, magoDeOz).
cree(gabriel, cavenaghi).
cree(juan, conejoDePascua).
cree(macarena, reyesMagos).
cree(macarena, magoCapria).
cree(macarena, campanita).

suenio(gabriel, ganarLoteria([5,9])).
suenio(gabriel, futbolista(arsenal)).
suenio(juan,cantante(100000)).
suenio(macarena, cantante(10000)).

equipo(arsenal, chico).
equipo(aldosivi, chico).
%Punto 2
ambiciosa(Persona):-
    suenio(Persona,_),
    dificultadSuenios(Persona, Dificultades),
    sumlist(Dificultades, DificultadTotal),
    DificultadTotal > 20.

dificultadSuenios(Persona, Dificultades):-
    suenio(Persona,_),
    findall(Dificultad, dificultadSuenio(Persona, _, Dificultad), Dificultades).

dificultadSuenio(Persona, ganarLoteria(NumerosApostados), Dificultad):-
    suenio(Persona, ganarLoteria(NumerosApostados)),
    length(NumerosApostados, CantNumerosApostados),
    Dificultad is CantNumerosApostados * 10.

dificultadSuenio(Persona, futbolista(Equipo), 3):-
    suenio(Persona, futbolista(Equipo)),
    equipo(Equipo, chico).
dificultadSuenio(Persona, futbolista(Equipo), 16):-
    suenio(Persona, futbolista(Equipo)),
    not(equipo(Equipo, chico)).

dificultadSuenio(Persona, cantante(Discos), 6):-
    suenio(Persona, cantante(Discos)),
    Discos > 500000.
dificultadSuenio(Persona, cantante(Discos), 4):-
    suenio(Persona, cantante(Discos)),
    Discos =< 500000.

%Punto 3
tieneQuimica(Personaje, Persona):-
    cree(Persona, Personaje),
    Personaje \= campanita,
    not(ambiciosa(Persona)),
    forall(suenio(Persona, Suenio), esSuenioPuro(Suenio)).
tieneQuimica(campanita, Persona):-
    cree(Persona, campanita),
    suenio(Persona, Suenio),
    dificultadSuenio(Persona, Suenio, Dificultad),
    Dificultad < 5.

esSuenioPuro(futbolista(_)).
esSuenioPuro(cantante(Discos)):-
    Discos < 200000.

%Punto 4
amigos(campanita, reyesMagos).
amigos(campanita, conejoDePascua).
amigos(conejoDePascua, cavenaghi).
enfermo(campanita).
enfermo(conejoDePascua).


alegra(Personaje, Persona):-
    suenio(Persona,_),
    tieneQuimica(Personaje, Persona),
    disponible(Personaje).

disponible(Personaje):-
    cree(_, Personaje),
    not(enfermo(Personaje)).
disponible(Personaje):-
    enfermo(Personaje),
    amigos(Personaje, OtroPersonaje),
    disponible(OtroPersonaje).
