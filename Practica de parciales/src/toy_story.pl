

dueno(andy, woody, 8).
dueno(sam, jessie, 3).

juguete(woody, deTrapo(vaquero)).
juguete(jessie, deTrapo(vaquero)).
juguete(buzz, deAccion(espacial, [original(casco)])).
juguete(soldados, miniFiguras(soldado, 60)).
juguete(monitosEnBarril, miniFiguras(mono, 50)).
juguete(senorCaraDePapa, caraDePapa([original(pieIzquierdo), original(pieDerecho), repuesto(nariz)])).

esRaro(deAccion(stacyMalibu, 1, [sombrero])).

esColeccionista(sam).

%Punto 1a
tematica(Juguete, Tematica):-
    juguete(Juguete, deTrapo(Tematica)).
tematica(Juguete, Tematica):-
    juguete(Juguete, deAccion(Tematica, _)).
tematica(Juguete, Tematica):-
    juguete(Juguete, miniFiguras(Tematica, _)).
tematica(Juguete, caraDePapa):-
    juguete(Juguete, caraDePapa(_)).

%Punto 1b
esDePlastico(Juguete):-
    juguete(Juguete, miniFiguras(_,_)).
esDePlastico(Juguete):-
    juguete(Juguete, caraDePapa(_)).

%Punto 1c
esDeColeccion(Juguete):-
    esFormaRara(Juguete).
esDeColeccion(Juguete):-
    juguete(Juguete, deTrapo(_)).

esFormaRara(Juguete):-
    esRaro(deAccion(Juguete, _, _)).
esFormaRara(Juguete):-
    esRaro(caraDePapa(Juguete, _, _)).

%Punto 2
amigoFiel(Dueno, Juguete):-
    dueno(Dueno, Juguete, Tiempo),
    not((dueno(Dueno, _, OtroTiempo), OtroTiempo > Tiempo)),
    not(esDePlastico(Juguete)).

%Punto 3
superValioso(Juguete):-
    dueno(Dueno, Juguete, _),
    not(esColeccionista(Dueno)),
    jugueteOriginal(Juguete).

jugueteOriginal(Juguete):-
    juguete(Juguete, deAccion(_, Lista)),
    todasPartesOriginales(Lista).
jugueteOriginal(Juguete):-
    juguete(Juguete, caraDePapa(Lista)),
    todasPartesOriginales(Lista).

todasPartesOriginales(Lista):-
    forall(member(Elemento, Lista), esOriginal(Elemento)).

esOriginal(original(_)).

%Punto 4
duoDinamico(Dueno, Juguete, OtroJuguete):-
    dueno(Dueno, Juguete, _),
    dueno(Dueno, OtroJuguete, _),
    Juguete \= OtroJuguete,
    hacenBuenaPareja(Juguete, OtroJuguete).

hacenBuenaPareja(woody, buzz).
hacenBuenaPareja(Juguete, OtroJuguete):-
    tematica(Juguete, Tematica),
    tematica(OtroJuguete, Tematica).

%Punto 5
felicidad(Dueno, FelicidadTotal):-
    dueno(Dueno, _, _),
    findall(Felicidad, (dueno(Dueno, Juguete, _), felicidadJuguete(Dueno, Juguete, Felicidad)), Felicidades),
    sum_list(Felicidades, FelicidadTotal).

felicidadJuguete(_, Juguete, Felicidad):-
    juguete(Juguete, miniFiguras(_, Cantidad)),
    Felicidad is Cantidad * 20.
felicidadJuguete(_, Juguete, Felicidad):-
    juguete(Juguete, caraDePapa(Lista)),
    findall(Objeto, pertenezcan(Objeto, Lista), Objetos),
    sum_list(Objetos, Felicidad).
felicidadJuguete(_, Juguete, 100):-
    juguete(Juguete, deTrapo(_)).

felicidad(Dueno, Juguete, 120):-
    juguete(Juguete, deAccion(_,_)),
    esDeColeccion(Juguete),
    esColeccionista(Dueno).

felicidad(Dueno, Juguete, 100):-
    juguete(Juguete, deAccion(_,_)),
    not((esDeColeccion(Juguete), esColeccionista(Dueno))).

pertenezcan(Objeto, Lista):-
    member(original(Objeto), Lista).
pertenezcan(Objeto, Lista):-
    member(repuesto(Objeto), Lista).

%Punto 6
puedeJugarCon(Alguien, Juguete):-
    dueno(Alguien, Juguete, _).
puedeJugarCon(Alguien, Juguete):-
    puedePrestarlo(OtroAlguien, Alguien),
    puedeJugarCon(OtroAlguien, Juguete).

puedePrestarlo(OtroAlguien, Alguien):-
    juguetesQueTiene(OtroAlguien, Cantidad1),
    juguetesQueTiene(Alguien, Cantidad2),
    Cantidad1 > Cantidad2.

juguetesQueTiene(Dueno, Cantidad):-
    dueno(Dueno,_,_),
    findall(Juguete, dueno(Dueno, Juguete,_), Juguetes),
    length(Juguetes, Cantidad).
    
%Punto 7
podriaDonar(Dueno, ListaJuguetes, FelicidadTotal):-
    felicidad(Dueno, FelicidadTotal),
