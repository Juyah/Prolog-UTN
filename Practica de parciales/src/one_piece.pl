
% Relaciona Pirata con Tripulacion
tripulante(luffy, sombreroDePaja).
tripulante(zoro, sombreroDePaja).
tripulante(nami, sombreroDePaja).
tripulante(ussop, sombreroDePaja).
tripulante(sanji, sombreroDePaja).
tripulante(chopper, sombreroDePaja).

tripulante(law, heart).
tripulante(bepo, heart). 

tripulante(arlong, piratasDeArlong).
tripulante(hatchan, piratasDeArlong).


% Relaciona Pirata, Evento y Monto
impactoEnRecompensa(luffy, arlongPark, 30000000).
impactoEnRecompensa(luffy, baroqueWorks, 70000000).
impactoEnRecompensa(luffy, eniesLobby, 200000000).
impactoEnRecompensa(luffy,  marineford, 100000000).
impactoEnRecompensa(luffy,  dressrosa, 100000000).

impactoEnRecompensa(zoro, baroqueWorks, 60000000).
impactoEnRecompensa(zoro, eniesLobby, 60000000).
impactoEnRecompensa(zoro, dressrosa, 200000000).

impactoEnRecompensa(nami, eniesLobby, 16000000).
impactoEnRecompensa(nami, dressrosa, 50000000).

impactoEnRecompensa(ussop, eniesLobby, 30000000).
impactoEnRecompensa(ussop, dressrosa, 170000000).

impactoEnRecompensa(sanji, eniesLobby, 77000000).
impactoEnRecompensa(sanji, dressrosa, 100000000).

impactoEnRecompensa(chopper, eniesLobby, 50).
impactoEnRecompensa(chopper, dressrosa, 100).

impactoEnRecompensa(law, sabaody, 200000000).
impactoEnRecompensa(law, descorazonamientoMasivo,
     240000000).
impactoEnRecompensa(law, dressrosa, 60000000).

impactoEnRecompensa(bepo,sabaody,500).

impactoEnRecompensa(arlong, llegadaAEastBlue, 20000000).
impactoEnRecompensa(hatchan, llegadaAEastBlue, 3000).

%Punto 1
participaron(Tripulacion, OtraTripulacion, Evento):-
    unPirataRecibioRecompensa(Tripulacion, Evento),
    unPirataRecibioRecompensa(OtraTripulacion, Evento),
    Tripulacion \= OtraTripulacion.

unPirataRecibioRecompensa(Tripulacion, Evento):-
    tripulante(Pirata, Tripulacion),
    impactoEnRecompensa(Pirata, Evento, _).

%Punto 2
masDestaco(Pirata, Evento):-
    impactoEnRecompensa(Pirata, Evento, RecompensaMasAlta),
    forall((impactoEnRecompensa(OtroPirata, Evento, Recompensa), OtroPirata \= Pirata), RecompensaMasAlta > Recompensa).
    %not((impactoEnRecompensa(OtroPirata, Evento, Recompensa), OtroPirata \= Pirata, RecompensaMasAlta < Recompensa)).

%Punto 3
desapercibio(Pirata, Evento):-
    tripulante(Pirata, Tripulacion),
    unPirataRecibioRecompensa(Tripulacion, Evento),
    not(impactoEnRecompensa(Pirata, Evento, _)).
    
%Punto 4
recompensaTotal(Tripulacion, RecompensaTotal):-
    esTripulacion(Tripulacion),
    findall(Recompensa, recompensas(Tripulacion, Recompensa), Recompensas),
    sumlist(Recompensas, RecompensaTotal).

esTripulacion(Tripulacion):-
    tripulante(_, Tripulacion).

recompensas(Tripulacion, Recompensa):-
    impactoEnRecompensa(Pirata, _, Recompensa), 
    tripulante(Pirata, Tripulacion).

%Punto 5
esTembile(Tripulacion):-
    esTripulacion(Tripulacion),
    requisitoTembile(Tripulacion).

requisitoTembile(Tripulacion):-
    forall(tripulante(Pirata, Tripulacion), esPeligroso(Pirata)).

requisitoTembile(Tripulacion):-
    recompensaTotal(Tripulacion, RecompensaTotal),
    RecompensaTotal > 500000000.

esPeligroso(Pirata):-
    recompensaTotalPirata(Pirata, Recompensa),
    Recompensa > 100000000.

recompensaTotalPirata(Pirata, RecompensaTotal):-
    esPirata(Pirata),
    findall(Recompensa, impactoEnRecompensa(Pirata,_, Recompensa), Recompensas),
    sumlist(Recompensas, RecompensaTotal).

esPirata(Pirata):-
    tripulante(Pirata, _).

%Punto 6

comio(luffy, paramecia(gomugomu)).
comio(buggy, paramecia(barabara)).
comio(law, paramecia(opeope)).
comio(chopper, zoan(hitohito, humano)).
comio(lucci, zoan(nekoneko, leopardo)).
comio(smoker, logia(mokumoku, humo)).
esFeroz(lobo).
esFeroz(leopardo).
esFeroz(anaconda).

esPeligroso(Pirata):-
    comio(Pirata, Fruta),
    frutaPeligrosa(Fruta).

frutaPeligrosa(logia(_,_)).
frutaPeligrosa(zoan(_, Animal)):-
    esFeroz(Animal).
frutaPeligrosa(paramecia(opeope)).

/*
Realize el predicado comio, que relaciona a un pirata con el tipo de fruta que comio.
El tipo de fruta es un functor, el cual si es una paramecia simplemente dira el nombre,
pero si es una zoan o una logia dira el nombre y en lo que puede transformarse. 
A pesar de que no utilizemos los nombres de las frutas en zoan y logia, 
me parece interesante mantener esa información en la base de conocimientos.
sacamos a esPeligroso de hacerse cargo de decir que cosa es peligrosa, sino que simplemente
nos diga un pirata que comió una fruta y luego, en frutaPeligrosa, se analiza si esa fruta es o no peligrosa.
*/

%Punto7
noPuedeNadar(Pirata):-
    comio(Pirata,_).

sonPiratasDelAsfalto(Tripulacion):-
    esTripulacion(Tripulacion),
    forall(tripulante(Pirata, Tripulacion), noPuedeNadar(Pirata)).