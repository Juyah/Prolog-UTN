/*
Nombre: Yarbuh, Juan Ignacio
Legajo: 169077-2
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Código Inicial
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

anterior(fecha(_, _, AnioAnterior), fecha(_, _ , Anio)):- AnioAnterior < Anio.
anterior(fecha(_, MesAnterior, Anio), fecha(_, Mes, Anio)):- MesAnterior < Mes.
anterior(fecha(DiaAnterior, Mes, Anio), fecha(Dia, Mes, Anio)):- DiaAnterior < Dia.

categoriaDisfraz(slash, musica).
categoriaDisfraz(madonna, musica).
categoriaDisfraz(madonna, sexy).
categoriaDisfraz(sailorMoon, anime).
categoriaDisfraz(hulk, cine).
categoriaDisfraz(hulk, superheroes).
categoriaDisfraz(samara, cine).
categoriaDisfraz(samara, terror).
categoriaDisfraz(elefanteRosado, llamativo).

eligioDisfraz(cumpleLuli2042, jochirock, slash).
eligioDisfraz(cumpleLuli2042, jacinta2020, sailorMoon).
eligioDisfraz(jochiween42, jochirock, madonna).

%fiesta(Nombre, fecha(Fecha), Organizador, tipo(Fiesta))
fiesta(cumpleLuli2042, fecha(27, 08, 2042), luli47, cumpleanios(hulk, 13)).
fiesta(jochiween42, fecha(1, 11, 2042), jochirock, halloween).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Punto 1
leInteresa(Persona, Disfraz):-
    tieneDifrazSimilar(Persona, Disfraz),
    not(uso(Persona, Disfraz)).

tieneDifrazSimilar(Persona, Disfraz):-
    uso(Persona, OtroDisfraz),
    mismaCategoria(Disfraz, OtroDisfraz).

mismaCategoria(Disfraz, OtroDisfraz):-
    categoriaDisfraz(OtroDisfraz, Categoria),
    categoriaDisfraz(Disfraz, Categoria),
    Disfraz \= OtroDisfraz.

%% Punto 2
esModa(Disfraz, Anio):-
    between(0, 9999, Anio),
    muyUsado(Disfraz, Anio),
    AnioAnterior is Anio - 1,
    not(muyUsado(Disfraz, AnioAnterior)).

muyUsado(Disfraz, Anio):-
    esDisfraz(Disfraz),
    forall(fiestaEnAnio(Fiesta, Anio), usoAlguien(Disfraz, Fiesta)).

%% Punto 3
esApropiado(Disfraz, halloween):-
    categoriaHallowen(Categoria),
    categoriaDisfraz(Disfraz, Categoria).
esApropiado(Disfraz, cumpleanios(DisfrazCumplaniero, Edad)):-
    esAdecuado(Disfraz, Edad),
    not(opaca(Disfraz, DisfrazCumplaniero)).

categoriaHallowen(terror).
categoriaHallowen(sexy).

esAdecuado(Disfraz, Edad):-
    Edad < 18,
    esDisfraz(Disfraz),
    not(categoriaDisfraz(Disfraz, sexy)).
esAdecuado(Disfraz, Edad):-
    Edad >= 18,
    esDisfraz(Disfraz).

opaca(Disfraz, DisfrazCumplaniero):-
    categoriaDisfraz(Disfraz, sexy),
    not(categoriaDisfraz(DisfrazCumplaniero, sexy)).
opaca(Disfraz, _):-
    categoriaDisfraz(Disfraz, llamativo).

%% Punto 4
sugerirPara(Persona, Disfraz, Fiesta):-
    esPersona(Persona), esDisfraz(Disfraz), fiestaDeTipo(Fiesta, Tipo),
    esApropiado(Disfraz, Tipo),
    not(eligioDisfraz(Fiesta, Persona, _)),
    deseaPara(Persona, Disfraz, Fiesta).

deseaPara(Persona, Disfraz, _):-
    leInteresa(Persona, Disfraz).
deseaPara(_, Disfraz, Fiesta):-
    fiestaEnAnio(Fiesta, Anio),
    esModa(Disfraz, Anio).

%% Punto 5
asistieron(Fiesta, Cantidad):-
    esFiesta(Fiesta),
    findall(Persona, eligioDisfraz(Fiesta, Persona,_), Personas),
    length(Personas, Cantidad).

%% Punto 6
esExitosa(Fiesta):-
    fiestaDeTipo(Fiesta, Tipo),
    forall(usoAlguien(Disfraz, Fiesta), esApropiado(Disfraz, Tipo)),
    buenNumeroAsistentes(Fiesta).

buenNumeroAsistentes(Fiesta):-
    asistieron(Fiesta, Cantidad),
    esPrimeraFiesta(Fiesta),
    Cantidad >= 10.
buenNumeroAsistentes(Fiesta):-
    esLaPrimerFiestaAnterior(Fiesta, FiestaAnterior),
    asistieron(Fiesta, Cantidad),
    asistieron(FiestaAnterior, CantidadAnterior),
    Cantidad >= CantidadAnterior + 3.

esLaPrimerFiestaAnterior(Fiesta, FiestaAnterior):-
    fiesta(Fiesta, Fecha, Persona, _),
    fiesta(FiestaAnterior, FechaAnterior, Persona, _),
    anterior(FechaAnterior, Fecha),
    not((fiesta(Test, FechaTest, Persona, _), anterior(FechaTest, Fecha), anterior(FechaAnterior, FechaTest))).

esPrimeraFiesta(Fiesta):-
    fiesta(Fiesta, Fecha, Persona, _),
    not((fiesta(_, OtraFecha, Persona,_), anterior(OtraFecha, Fecha))).

/* Para testear el predicado de buenNumeroAsistentes hay que comentar el punto 5 y descomentar estos predicados
Si no se comenta el punto 5 moraInvitaX tendra el numero puesto como hecho y el numero puesto por la regla que sera 0.
Tambien se puede probar que si es la primer fiesta anterior.

fiesta(moraInvita1, fecha(20, 4, 2040), mora1, cualquierCosa).
fiesta(moraInvita2, fecha(29, 4, 2040), mora1, cualquierCosa).
fiesta(moraInvita3, fecha(15, 8, 2041), mora1, cualquierCosa).
fiesta(moraInvita4, fecha(29, 10, 2041), mora1, cualquierCosa).
asistieron(moraInvita1, 15).
asistieron(moraInvita2, 17).
asistieron(moraInvita3, 22).
asistieron(moraInvita4, 23).
*/

%% Punto 7
/*
Los tipos de fiestas estan considerados como atomos o functores en caso de necesitar que se añada mas informacion.
Por lo tanto, cuando se añade un predicado de un nuevo tipo, se especifica en el hecho.
Sobre los predicados: El predicado esApropiado trabaja polimorficamente, hay que añadir el tipo de fiesta nuevo y crear los requisitos 
que se requieran.

Una fiesta para disfrazes llamativos y que le gustan al que tomo parcial.
*/
%%%%%%%%%%%%%%%%%%%%Demostración%%%%%%%%%%%%%%%%%%%%
fiesta(utn, fecha(26, 08, 2020), pdep, parcial(matos)).

esApropiado(Disfraz, parcial(Profesor)):-
    categoriaDisfraz(Disfraz, llamativo),
    leGusta(Profesor, Disfraz).

leGusta(matos, elefanteRosado).
leGusta(matos, madonna).
leGusta(matos, queen).

leGusta(mora, angelinaJolie).
leGusta(mora, elefanteRosado).
leGusta(mora, onePunch).

%%%%%%%%%%%%%%%%%%%%Predicados generales%%%%%%%%%%%%%%%%%%%%
esPersona(Persona):-
    eligioDisfraz(_, Persona, _).

fiestaEnAnio(Fiesta, Anio):-
    fiesta(Fiesta, fecha(_,_, Anio),_,_).

esDisfraz(Disfraz):-
    categoriaDisfraz(Disfraz, _).

fiestaDeTipo(Fiesta, Tipo):-
    fiesta(Fiesta, _,_,Tipo).

esFiesta(Fiesta):-
    fiesta(Fiesta,_,_,_).

uso(Persona, Disfraz):-
    eligioDisfraz(_, Persona, Disfraz).

usoAlguien(Disfraz, Fiesta):-
    eligioDisfraz(Fiesta, _, Disfraz).

%%%%%%%%%%%%%%%%%%%%Ampliando%%%%%%%%%%%%%%%%%%%% 
%Para probar predicado de una fiesta exitosa, moraInvita.
esApropiado(Disfraz, cualquierCosa):-
    esDisfraz(Disfraz).

categoriaDisfraz(batman, superheroes).
categoriaDisfraz(superman, superheroes).
categoriaDisfraz(superman, cine).
categoriaDisfraz(diva, sexy).
categoriaDisfraz(onePunch, anime).
categoriaDisfraz(goku, anime).
categoriaDisfraz(bradPitt, cine).
categoriaDisfraz(bradPitt, sexy).
categoriaDisfraz(angelinaJolie, cine).
categoriaDisfraz(angelinaJolie, llamativo).

eligioDisfraz(superHeroes, jochirock, goku).
eligioDisfraz(superHeroes, luli47, angelinaJolie).
eligioDisfraz(superHeroes, matos, batman).
eligioDisfraz(superHeroes, mora, onePunch).
eligioDisfraz(aburrida, luli47, elefanteRosado).
eligioDisfraz(moraInvita, luli47, batman).
eligioDisfraz(moraInvita, matos, superman).
eligioDisfraz(moraInvita, mora, onePunch).
eligioDisfraz(moraInvita, jochirock, diva).
eligioDisfraz(moraInvita, esteban, bradPitt).
eligioDisfraz(moraInvita, fernando, slash).
eligioDisfraz(moraInvita, susana, angelinaJolie).
eligioDisfraz(moraInvita, emi, bradPitt).
eligioDisfraz(moraInvita, bianca, samara).
eligioDisfraz(moraInvita, claudia, angelinaJolie).
eligioDisfraz(moraInvita, max, elefanteRosado).
eligioDisfraz(moraInvita, ricardo, hulk).

fiesta(superHeroes, fecha(1, 11, 2031), luli47, parcial(mora)).
fiesta(aburrida, fecha(1, 11, 2050), jochirock, cumpleanios(angelinaJolie, 12)).
fiesta(moraInvita, fecha(1, 11, 2020), mora, cualquierCosa).