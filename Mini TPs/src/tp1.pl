% No cambies esta declaración del módulo tp1, ya que podría traer
% problemas para correr las pruebas del proyecto.
:- module(tp1, [leGusta/2, puedePedir/2]).

% ---------------------------------------------------------------------------- %

precio(asado,550).
precio(lomitoDeLaCasa,450).
precio(hamburguesa,350).
precio(papasFritas,220).
precio(ensalada,190).
precio(pizzetas, 250).
precio(polloALaPlancha, 320).
precio(tostadoVeggie, 150).

tieneCarne(asado).
tieneCarne(hamburguesa).
tieneCarne(lomitoDeLaCasa).
tieneCarne(polloALaPlancha).

%----------------------------------------------------------------------------------------------------------------------
% Cambiar la implementación para el predicado leGusta/2 de modo que relacione a una persona con una comida (en ese orden).
leGusta(juan, asado).
leGusta(gabriel, asado).
leGusta(gabriel, Comida):-
        precio(Comida, Precio),
        Precio < 300.
leGusta(juan, tostadoVeggie).
leGusta(soledad, Comida):-
        leGusta(gabriel, Comida),
        not(leGusta(juan, Comida)).
leGusta(tomas, Comida):-
        tieneCarne(Comida).
leGusta(celeste, Comida):-
        precio(Comida, _).
%Como lo que no se encuentre en nuestros predicados es "falso", Carolina no esta, por lo tanto no le gusta nada :D
%----------------------------------------------------------------------------------------------------------------------

%----------------------------------------------------------------------------------------------------------------------
% Cambiar la implementación para el predicado puedePedir/2 de modo que relacione a una persona con una comida (en ese orden).
puedePedir(Persona, Comida):-
        leGusta(Persona, Comida),
        precio(Comida, Precio),
        puedeGastar(Persona, Dinero),
        Precio =< Dinero.

puedeGastar(juan, 500).
puedeGastar(celeste, 400).
puedeGastar(soledad, DineroTomas*2):-
        puedeGastar(tomas, DineroTomas).
puedeGastar(tomas, PrecioHamburguesa):-
        precio(hamburguesa, PrecioHamburguesa).
puedeGastar(gabriel, DineroCarolina/2):-
        puedeGastar(carolina, DineroCarolina).
puedeGastar(carolina, PrecioAsado + PrecioFritas):-
        precio(asado, PrecioAsado),
        precio(papasFritas, PrecioFritas).
%----------------------------------------------------------------------------------------------------------------------

% --------------------------------
% TESTS - NO TOCAR
% --------------------------------

:- begin_tests(tests_tp1_leGusta).

test(genteALaQueLeGustaElAsado, set(Persona == [juan, gabriel, celeste, tomas])):-
        leGusta(Persona, asado).

test(gustosDeJuan, set(Comida == [asado, tostadoVeggie])):-
        leGusta(juan, Comida).

test(gustosDeGabriel, set(Comida == [asado, papasFritas, ensalada, pizzetas, tostadoVeggie])):-
        leGusta(gabriel, Comida).

test(gustosDeSoledad, set(Comida == [papasFritas, ensalada, pizzetas])):-
        leGusta(soledad, Comida).

test(gustosDeTomas, set(Comida == [asado, hamburguesa, lomitoDeLaCasa, polloALaPlancha])):-
        leGusta(tomas, Comida).

test(gustosDeCeleste, set(Comida == [asado, lomitoDeLaCasa, hamburguesa, papasFritas, ensalada, pizzetas, polloALaPlancha, tostadoVeggie])):-
        leGusta(celeste, Comida).

test(aCarolinaNoLeGustaNada, fail):-
        leGusta(carolina, _).

:- end_tests(tests_tp1_leGusta).

:- begin_tests(tests_tp1_puedePedir).

test(genteQuePuedePedirHamburguesa, set(Persona == [celeste, tomas])):-
        puedePedir(Persona, hamburguesa).

test(nadiePuedePedirAsado, fail):-
        puedePedir(_, asado).

test(aCelesteNoLeAlcanzaParaPedirElLomito, fail):-
        puedePedir(celeste, lomitoDeLaCasa).

test(aCelesteLeAlcanzaParaPedirPollo, nondet):-
        puedePedir(celeste, polloALaPlancha).

test(comidasQuePuedePedirJuan, set(Comida == [tostadoVeggie])):-
        puedePedir(juan, Comida).

test(comidasQuePuedePedirSoledad, set(Comida == [papasFritas, ensalada, pizzetas])):-
        puedePedir(soledad, Comida).

test(comidasQuePuedePedirTomas, set(Comida == [hamburguesa, polloALaPlancha])):-
        puedePedir(tomas, Comida).

test(comidasQuePuedePedirGabriel, set(Comida == [papasFritas, ensalada, pizzetas, tostadoVeggie])):-
        puedePedir(gabriel, Comida).

test(carolinaNoPuedePedirNadaPorqueNoLeGustaLoQueHay, fail):-
        puedePedir(carolina, _).

:- end_tests(tests_tp1_puedePedir).