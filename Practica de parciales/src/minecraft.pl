jugador(stuart, [piedra, piedra, piedra, piedra, piedra, piedra, piedra, piedra], 3).
jugador(tim, [madera, madera, madera, madera, madera, pan, carbon, carbon, carbon, pollo, pollo], 8).
jugador(steve, [madera, carbon, carbon, diamante, panceta, panceta, panceta], 2).

%lugar(zona, personajes adentro, nivel oscuridad).
lugar(playa, [stuart, tim], 2).
lugar(mina, [steve], 8).
lugar(bosque, [], 6).

comestible(pan).
comestible(panceta).
comestible(pollo).
comestible(pescado).

%Punto 1.a  - Juani
tieneItem(Jugador, Item):-
    jugador(Jugador, ListaItems, _),
    member(Item, ListaItems).
%Punto 1.b  - Juani
sePreocupaPorSuSalud(Jugador):-
    jugador(Jugador, ListaItems, _),
    tieneItem(Jugador, Item),
    tieneItem(Jugador, Item2),
    nth1(Index, ListaItems, Item),
    nth1(Index2, ListaItems, Item2),
    Index \= Index2,
    comestible(Item2),
    comestible(Item).
%Punto 1.c  - Juani
cantidadDeItem(Jugador, Item, Cantidad):-
    jugador(Jugador, _, _),
    tieneItem(_, Item),
    findall(Item, tieneItem(Jugador, Item), ListaDelItem),
    length(ListaDelItem, Cantidad).
%Punto 1.d  - Juani
tieneMasDe(Jugador, Item):-
    jugador(Jugador,_,_),
    cantidadDeItem(Jugador, Item, Cantidad),
    forall((cantidadDeItem(OtroJugador, Item, OtraCantidad), OtroJugador \= Jugador), Cantidad > OtraCantidad).
%Punto 2.a  - Juani
hayMonstruos(Lugar):-
    lugar(Lugar, _, Oscuridad),
    6 < Oscuridad.
%Punto 2.b  - Juani
correPeligro(Jugador):-
    jugador(Jugador,_,_),
    lugar(Lugar, Jugadores, _),
    member(Jugador, Jugadores),
    hayMonstruos(Lugar).
correPeligro(Jugador):-
    hambriento(Jugador),
    not((tieneItem(Jugador, Item), comestible(Item))).

hambriento(Jugador):-
    jugador(Jugador,_,Hambre),
    Hambre < 4.
%Punto 2.c  - Juani
nivelPeligrosidad(Lugar, 100):-
    hayMonstruos(Lugar).
nivelPeligrosidad(Lugar, Nivel):-
    lugar(Lugar, ListaJugadores, _),
    not(hayMonstruos(Lugar)),
    not(length(ListaJugadores, 0)),
    findall(Jugador, (member(Jugador, ListaJugadores), hambriento(Jugador)),Hambrientos),
    length(Hambrientos, CantidadHambrientos),
    length(ListaJugadores, CantidadTotal),
    Nivel is CantidadHambrientos * 100/ CantidadTotal.
nivelPeligrosidad(Lugar, Nivel):-
    lugar(Lugar, ListaJugadores, Oscuridad),
    length(ListaJugadores, 0),
    Nivel is Oscuridad*10.
%Punto 3  - Juani
item(horno, [ itemSimple(piedra, 8) ]).
item(placaDeMadera, [ itemSimple(madera, 1) ]).
item(palo, [ itemCompuesto(placaDeMadera) ]).
item(antorcha, [ itemCompuesto(palo), itemSimple(carbon, 1) ]).

puedeConstruir(Jugador, Item):-
    jugador(Jugador,_,_),
    item(Item, ListaItems),
    not(member(itemCompuesto(_), ListaItems)),
    construirItemConSimple(Jugador, ListaItems).
puedeConstruir(Jugador, Item):-
    jugador(Jugador,_,_),
    item(Item, ListaItems),
    listaSimple(ListaItems, ListaSimple),
    listaCompuesta(ListaItems, ListaCompuesta).
    construirItemConSimple(Jugador, ListaSimple).
    forall(member(itemCompuesto(ItemGrande), ListaCompuesta), (item(ItemGrande, Lista2),construirItemConSimple(Jugador, Lista2))).

construirItemConSimple(Jugador, ListaItems):-
    forall(member(itemSimple(MiniItem, Cantidad), ListaItems), (cantidadDeItem(Jugador, MiniItem, Cantidad2), Cantidad2 >= Cantidad)).
    
listaSimple(ListaItems, ListaSimple):-
    findall(itemSimple(MiniItem,Cantidad), member(itemSimple(MiniItem,Cantidad),ListaItems), ListaSimple).
listaCompuesta(ListaItems, ListaCompuesta):-
    findall(Item, member(itemCompuesto(Item),ListaItems), ListaCompuesta).
%Punto 4.a  - Juani
%Sera falso, pues el desierto no es parte de nuestra base de conocimientos.
%Punto 4.b  - Juani
%La ventaja es que se le puede realizar, si esta debidamente desarrollado, quienes cumplen esa consulta.



































































