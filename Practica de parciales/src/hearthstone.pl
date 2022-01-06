/*
% jugadores
jugador(Nombre, PuntosVida, PuntosMana, CartasMazo, CartasMano, CartasCampo).

% cartas
criatura(Nombre, PuntosDanio, PuntosVida, CostoMana).
hechizo(Nombre, FunctorEfecto, CostoMana).

% efectos
daño(CantidadDanio).
cura(CantidadCura).
*/
jugador(eva, 130, 10, [agua,fuego], [viento], [latido]).
jugador(manu, 100, 25, [agua,hielo,fuego], [tierra, viento], [vapor, sudor]).
criatura(agua, 15, 55, 10).
criatura(fuego, 20, 40, 12).
criatura(viento, 25, 300, 50).
criatura(latido, 25, 300, 50).
hechizo(hielo, danio(24), 10).
hechizo(tierra, danio(33), 5).
hechizo(vapor, cura(25), 8).
hechizo(sudor, cura(55), 18).


nombre(jugador(Nombre,_,_,_,_,_), Nombre).
nombre(criatura(Nombre,_,_,_), Nombre).
nombre(hechizo(Nombre,_,_), Nombre).

vida(jugador(_,Vida,_,_,_,_), Vida).
vida(criatura(_,_,Vida,_), Vida).
vida(hechizo(_,curar(Vida),_), Vida).

danio(criatura(_,Danio,_), Danio).
danio(hechizo(_,danio(Danio),_), Danio).
mana(jugador(_,_,Mana,_,_,_), Mana).
mana(criatura(_,_,_,Mana), Mana).
mana(hechizo(_,_,Mana), Mana).

cartasMazo(jugador(_,_,_,Cartas,_,_), Cartas).
cartasMano(jugador(_,_,_,_,Cartas,_), Cartas).
cartasCampo(jugador(_,_,_,_,_,Cartas), Cartas).

%Punto 1
tieneCarta(Jugador, Carta):-
    esJugador(Jugador),
    esCarta(Carta),
    cartasDelJugador(Jugador, Cartas),
    member(Carta, Cartas).

cartasDelJugador(Jugador, Cartas):-
    findall(Carta, (cartasJugadorTipo(Jugador, CartasTipo), member(Carta, CartasTipo)), Cartas).
cartasJugadorTipo(Jugador, Cartas):-
    jugador(Jugador,_,_,Cartas,_,_).
cartasJugadorTipo(Jugador, Cartas):-
    jugador(Jugador,_,_,_,Cartas,_).
cartasJugadorTipo(Jugador, Cartas):-
    jugador(Jugador,_,_,_,_,Cartas).

esJugador(Jugador):-
    jugador(Jugador,_,_,_,_,_).

esCarta(Carta):-
    criatura(Carta, _, _, _).
esCarta(Carta):-
    hechizo(Carta, _, _).

%Punto 2
esGuerrero(Jugador):-
    esJugador(Jugador),
    cartasDelJugador(Jugador, Cartas),
    forall(member(Carta, Cartas), criatura(Carta,_,_,_)).

%Punto 3
turnoEmpezado(Jugador, Jugador).
