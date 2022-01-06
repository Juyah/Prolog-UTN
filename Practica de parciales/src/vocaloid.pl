
%canta(Vocaloid, cancion(Nombre, Duracion)).
canta(megurineLuka, cancion(nightFever, 4)).
canta(megurineLuka, cancion(foreverYoung, 5)).
canta(hatsuneMiku, cancion(tellYourWorld, 4)).
canta(gumi, cancion(foreverYoung, 4)).
canta(gumi, cancion(tellYourWorld, 5)).
canta(seeU, cancion(novemberRain, 6)).
canta(seeU, cancion(nightFever, 5)).

vocaloid(Vocaloid):-
    canta(Vocaloid,_).

%Punto a.1
esNovedoso(Vocaloid):-
    sabe2CancionesDistintas(Vocaloid),
    duracionDeTodasSusCanciones(Vocaloid, Duracion),
    Duracion < 15.

sabe2CancionesDistintas(Vocaloid):-
    vocaloid(Vocaloid),
    canta(Vocaloid, cancion(Cancion, _)),
    canta(Vocaloid, cancion(OtraCancion,_)),
    Cancion \= OtraCancion.

duracionDeTodasSusCanciones(Vocaloid, DuracionTotal):-
    vocaloid(Vocaloid),
    findall(Duracion, canta(Vocaloid, cancion(_,Duracion)), Duraciones),
    sum_list(Duraciones, DuracionTotal).
    
%Punto a.2
esAcelerado(Vocaloid):-
    canta(Vocaloid,_),
    not((canta(Vocaloid, cancion(_, Duracion)), Duracion > 4)).

%Punto b.1
%gigante(Canciones, DuracionesMinimas).
%mediano(DuracionTotal).
%pequeño(AlgunaCancionDureMinimo).
%concierto(Nombre, Lugar, Fama, tipoConcierto).
concierto(mikuExpo, estadosUnidos, 2000, gigante(2, 6)).
concierto(magicalMirai, japon, 3000, gigante(3, 10)).
concierto(vocalektVisions, estadosUnidos, 1000, mediano(9)).
concierto(mikuFest, argentina, 100, pequenio(4)).

%Punto b.2
puedeParticipar(Vocaloid, Concierto):-
    vocaloid(Vocaloid),
    concierto(Concierto, _, _, TipoConcierto),
    cumpleRequisitos(Vocaloid, TipoConcierto).
puedeParticipar(hatsuneMiku, Concierto):-
    concierto(Concierto, _, _, _).

cumpleRequisitos(Vocaloid, gigante(CantidadCanciones, DuracionesMinimas)):-
    cancionesQueSabe(Vocaloid, Cantidad),
    Cantidad > CantidadCanciones,
    duracionDeTodasSusCanciones(Vocaloid, DuracionTotal),
    DuracionTotal > DuracionesMinimas.
cumpleRequisitos(Vocaloid, mediano(Duracion)):-
    duracionDeTodasSusCanciones(Vocaloid, DuracionTotal),
    DuracionTotal < Duracion.
cumpleRequisitos(Vocaloid, pequenio(DuracionMinima)):-
    canta(Vocaloid, cancion(_, Duracion)),
    Duracion > DuracionMinima.

cancionesQueSabe(Vocaloid, Cantidad):-
    vocaloid(Vocaloid),
    findall(Cancion, canta(Vocaloid, cancion(Cancion, _)), Canciones),
    length(Canciones, Cantidad).

%Punto b.3
masFamoso(Vocaloid):-
    nivelFama(Vocaloid, Fama),
    not((nivelFama(OtroVocaloid, OtraFama), OtroVocaloid \= Vocaloid, OtraFama >= Fama)).

nivelFama(Vocaloid, Fama):-
    vocaloid(Vocaloid),
    findall(Concierto, distinct(puedeParticipar(Vocaloid, Concierto)), Conciertos),
    famaTotalConciertos(Conciertos, FamaConciertos),
    cancionesQueSabe(Vocaloid, CantidadCanciones),
    Fama is FamaConciertos * CantidadCanciones.

famaTotalConciertos(Conciertos, FamaTotal):-
    findall(Fama, (member(Concierto, Conciertos), concierto(Concierto,_,Fama,_)) , FamaConciertos),
    sumlist(FamaConciertos, FamaTotal).
    
%Punto b.4
conocidoDirecto(megurineLuka, hatsuneMiku).
conocidoDirecto(megurineLuka, gumi).
conocidoDirecto(gumi, seeU).
conocidoDirecto(seeU, kaito).

unicoParticipanteEnConocidos(Vocaloid, Concierto):-
    puedeParticipar(Vocaloid, Concierto), 
    not((puedeParticipar(OtroVocaloid, Concierto), conocido(Vocaloid, OtroVocaloid))).

conocido(Vocaloid, OtroVocaloid):-
    conocidoDirecto(Vocaloid, OtroVocaloid).
conocido(Vocaloid, OtroVocaloid):-
    conocidoDirecto(Vocaloid, UnVocaloid),
    conocido(UnVocaloid, OtroVocaloid).

%Punto b.5
/*
Si aparece un nuevo tipo de concierto no es problema pues hicimos el predicado puedeParticipar polimorfico.
Solo se deberia de añadir en cumpleRequisitos, lo que ese tipo de concierto pide.
El polimorfismo facilito realizar ese cambio de tipo de concierto.
*/