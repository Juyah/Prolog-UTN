herramienta(ana, circulo(50,3)).
herramienta(ana, cuchara(40)).
herramienta(beto, circulo(20,1)).
herramienta(beto, libro(inerte)).
herramienta(cata, libro(vida)).
herramienta(cata, circulo(100,5)).

%Punto 1

elementos(ana, [agua,vapor,tierra,hierro]).
elementos(beto, Lista):-
    elementos(ana, Lista).
elementos(cata, [fuego, tierra, agua, aire]).

construir(pasto, agua).
construir(pasto, tierra).
construir(hierro, fuego). 
construir(hierro, agua).
construir(hierro, tierra).
construir(huesos, pasto).
construir(huesos, agua).
construir(presion, hierro).
construir(presion, vapor).
construir(vapor, agua).
construir(vapor, fuego).
construir(playStation, silicio).
construir(playStation, hierro).
construir(playStation, plastico).
construir(silicio, tierra).
construir(plastico, huesos).
construir(plastico, presion).

esElementoCompuesto(Elemento):-
    construir(Elemento,_).

esJugador(Persona):-
    elementos(Persona,_).

%Punto 2

tieneIngredientesPara(Persona, Elemento):-
    esJugador(Persona),
    esElementoCompuesto(Elemento),
    forall(construir(Elemento, Ingrediente), tiene(Persona, Ingrediente)).

tiene(Persona, Ingrediente):-
    elementos(Persona, Lista),
    member(Ingrediente, Lista),
    not(esElementoCompuesto(Ingrediente)).

tiene(Persona, Ingrediente):-
    esElementoCompuesto(Ingrediente),
    tieneIngredientesPara(Persona, Ingrediente).

%Punto 3
estaVivo(agua).
estaVivo(fuego).
estaVivo(Elemento):-
    construir(Elemento, Ingrediente),
    estaVivo(Ingrediente).

%Punto 4
puedeConstruir(Persona, Elemento):-
    tieneIngredientesPara(Persona, Elemento),
    herramienta(Persona, Herramienta),
    sirve(Herramienta, Elemento).

sirve(libro(vida), Elemento):-
    estaVivo(Elemento).
sirve(libro(inerte), Elemento):-
    not(estaVivo(Elemento)).
sirve(cuchara(Longitud), Elemento):-
    Soportan is Longitud / 10,
    soporta(Elemento, Soportan).
sirve(circulos(Diametro, Nivel), Elemento):-
    Soportan is Diametro * Nivel,
    soporta(Elemento, Soportan).

soporta(Elemento, Soportan):-
    cantidadIngredientes(Elemento, Cantidad),
    Soportan >= Cantidad.

cantidadIngredientes(Elemento, Cantidad):-
    esElementoCompuesto(Elemento),
    findall(Ingrediente, construir(Elemento, Ingrediente), Ingredientes),
    length(Ingredientes, Cantidad).
    

%Punto 5
todoPoderoso(Persona):-
    elementos(Persona, Lista),
    forall(elemetoPrimitivo(Elemento), member(Elemento, Lista)),
    forall(construir(Elemento,_), (herramienta(Persona, Herramienta), sirve(Herramienta, Elemento))).

elemetoPrimitivo(Elemento):-
    construir(_, Elemento),
    not(construir(Elemento,_)).

%Punto 6
quienGana(Persona):-
    construye(Persona, Cantidad),
    not((construye(_, OtraCantidad), OtraCantidad > Cantidad )).

construye(Persona, Cantidad):-
    esJugador(Persona),
    findall(Elemento, distinct(puedeConstruir(Persona, Elemento)), Elementos),
    length(Elementos, Cantidad).

%Punto 7
/*
En el punto 1 cuando se aclara que Cata no tiene vapor, no se lo hizo como un hecho, pues al trabajar en 
universo cerrado simplemente no colocando que Cata tiene vapor se toma como que no tiene. 
Todo lo que no sea hecho o se deduzca de las reglas estara fuera de mi universo y por lo tanto sera falso.
*/
