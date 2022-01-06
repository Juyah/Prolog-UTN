
anioActual(2015).

%festival(nombre, lugar, bandas, precioBase).
%lugar(nombre, capacidad).
festival(lulapaluza, lugar(hipodromo,40000), [miranda, paulMasCarne, muse], 500).
festival(mostrosDelRock, lugar(granRex, 10000), [kiss, judasPriest, blackSabbath], 1000).
festival(personalFest, lugar(geba, 5000), [tanBionica, miranda, muse, pharrellWilliams], 300).
festival(cosquinRock, lugar(aerodromo, 2500), [erucaSativa, laRenga], 400).

%banda(nombre, año, nacionalidad, popularidad).
banda(paulMasCarne,1960, uk, 70).
banda(muse,1994, uk, 45).
banda(kiss,1973, us, 63).
banda(erucaSativa,2007, ar, 60).
banda(judasPriest,1969, uk, 91).
banda(tanBionica,2012, ar, 71).
banda(miranda,2001, ar, 38).
banda(laRenga,1988, ar, 70).
banda(blackSabbath,1968, uk, 96).
banda(pharrellWilliams,2014, us, 85).

%entradasVendidas(nombreDelFestival, tipoDeEntrada, cantidadVendida).
% tipos de entrada: campo, plateaNumerada(numero de fila), plateaGeneral(zona).
entradasVendidas(lulapaluza,campo, 600).
entradasVendidas(lulapaluza,plateaGeneral(zona1), 200).
entradasVendidas(lulapaluza,plateaGeneral(zona2), 300).
entradasVendidas(mostrosDelRock,campo,20000).
entradasVendidas(mostrosDelRock,plateaNumerada(1),40).
entradasVendidas(mostrosDelRock,plateaNumerada(2),0).
entradasVendidas(mostrosDelRock,plateaNumerada(10),25).
entradasVendidas(mostrosDelRock,plateaGeneral(zona1),300).
entradasVendidas(mostrosDelRock,plateaGeneral(zona2),500).

plusZona(hipodromo, zona1, 55).
plusZona(hipodromo, zona2, 20).
plusZona(granRex, zona1, 45).
plusZona(granRex, zona2, 30).
plusZona(aerodromo, zona1, 25).

%Punto 1
estaDeModa(Banda):-
    banda(Banda, AnoFundado,_, Popularidad),
    anioActual(AnoActual),
    Popularidad > 70,
    AnoFundado >= AnoActual - 5.

%Punto 2
esCareta(Festival):-
    estaDeModa(Banda),    estaDeModa(OtraBanda),    Banda \= OtraBanda,
    tocaEn(Banda, Festival),
    tocaEn(OtraBanda, Festival).

esCareta(Festival):-
    festival(Festival,_,_,_),
    not(entradaRazonable(Festival,_)).

esCareta(Festival):-
    tocaEn(miranda, Festival).

tocaEn(Banda, Festival):-
    festival(Festival, _, Bandas,_),
    member(Banda, Bandas).

%Punto 3
entradaRazonable(Festival, plateaGeneral(Zona)):-
    festival(Festival, lugar(Lugar, _),_, PrecioEntrada),
    entradasVendidas(Festival, plateaGeneral(Zona), _),
    precioPlateaGeneral(Lugar, Zona, PrecioEntrada, Precio),
    plateaGeneral(Lugar, Zona, Precio).
    %plateaGeneral(Lugar, Zona, PrecioEntrada).

entradaRazonable(Festival, campo):-
    festival(Festival, _,_, PrecioEntrada),
    entradasVendidas(Festival, campo, _),
    popularidad(Festival, PopularidadFestival),
    PrecioEntrada < PopularidadFestival.

entradaRazonable(Festival, plateaNumerada(Fila)):-
    festival(Festival, _, Bandas, PrecioEntrada),
    not((member(Banda, Bandas), estaDeModa(Banda))),
    entradasVendidas(Festival, plateaNumerada(Fila), _),
    precioPlateaNumerada(Fila, PrecioEntrada, Precio),
    Precio =< 750.
    %PrecioEntrada =< 750.

entradaRazonable(Festival, plateaNumerada(Fila)):-
    festival(Festival, lugar(_, Capacidad), _, PrecioEntrada),
    popularidad(Festival, PopularidadFestival),
    entradasVendidas(Festival, plateaNumerada(Fila), _),
    precioPlateaNumerada(Fila, PrecioEntrada, Precio),
    Precio < Capacidad / PopularidadFestival.
    %PrecioEntrada < Capacidad / PopularidadFestival.


plateaGeneral(Lugar, Zona, Precio):-
    plusZona(Lugar, Zona, Plus),
    Plus < Precio / 10.

precioPlateaGeneral(Lugar, Zona, PrecioEntrada, Precio):-
    plusZona(Lugar, Zona, Plus),
    Precio is PrecioEntrada + Plus.

popularidad(Festival, PopularidadFestival):-
    festival(Festival, _, Bandas, _),
    findall(Popularidad, (member(Banda, Bandas), banda(Banda,_,_,Popularidad)), Popularidades),
    sum_list(Popularidades, PopularidadFestival).

precioPlateaNumerada(Fila, PrecioEntrada, Precio):-
    Precio is PrecioEntrada + 200 / Fila.

%Punto 4
nacanpop(Festival):-
    entradaRazonable(Festival, _),
    forall(tocaEn(Banda, Festival), banda(Banda,_,ar,_)).

%Punto 5
recaudacion(Festival, Recaudacion):-
    festival(Festival,_,_,_),
    findall(Precio, (entradasVendidas(Festival, Tipo, Cantidad), obtenerPrecio(Festival, Tipo, Cantidad, Precio)), Precios),
    sum_list(Precios, Recaudacion).

obtenerPrecio(Festival, campo, Cantidad, Precio):-
    festival(Festival,_,_,PrecioEntrada),
    Precio is Cantidad * PrecioEntrada.

obtenerPrecio(Festival, plateaGeneral(Zona), Cantidad, PrecioTotal):-
    festival(Festival,lugar(Lugar,_),_,PrecioEntrada),
    precioPlateaGeneral(Lugar, Zona, PrecioEntrada, Precio),
    PrecioTotal is Cantidad * Precio.

obtenerPrecio(Festival, plateaNumerada(Fila), Cantidad, PrecioTotal):-
    festival(Festival,_,_,PrecioEntrada),
    precioPlateaNumerada(Fila, PrecioEntrada, Precio),
    PrecioTotal is Precio * Cantidad.

%Punto 6
estaBienPlaneado(Festival):-
    festival(Festival,_, Bandas, _),
    crecePopularidad(Bandas),
    last(Bandas, UltimaBanda),
    esLegendaria(UltimaBanda).

crecePopularidad([X,Y]):-
    banda(X,_,_,PopularidadX),
    banda(Y,_,_,PopularidadY),
    PopularidadX < PopularidadY.

crecePopularidad([X, Y | Cola]):-
    banda(X,_,_,PopularidadX),
    banda(Y,_,_,PopularidadY),
    PopularidadX < PopularidadY,
    crecePopularidad([Y | Cola]).

esLegendaria(Banda):-
    banda(Banda,Ano, Nac, Popularidad),
    Ano < 1980,
    Nac \= ar,
    not((banda(OtraBanda,_,_,OtraPopularidad), estaDeModa(OtraBanda), OtraPopularidad > Popularidad)).