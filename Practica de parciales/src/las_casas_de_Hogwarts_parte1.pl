%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parte 1 - Sombrero Seleccionador
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mago(harry, mestiza).
mago(draco, puro).
mago(hermione, impura).
mago(ron, humana).
mago(erik,elfo).
mago(bonemon, tigre).

casa(gryffindor).
casa(slytherin).
casa(ravenclaw).
casa(hufflepuff).

odia(harry, slytherin).
odia(draco, hufflepuff).

corajudo(harry).

amistoso(harry).
amistoso(ron).
amistoso(erik).
amistoso(bonemon).

orgulloso(harry).
orgulloso(draco).
orgulloso(hermione).

inteligente(harry).
inteligente(draco).
inteligente(hermione).

responsable(hermione).

puedeEntrar(Mago, Casa):-
    mago(Mago, _),
    casa(Casa),
    Casa \= slytherin.

puedeEntrar(Mago, slytherin):-
    mago(Mago, _),
    not(mago(Mago, impura)).

caracterApropiado(Mago, gryffindor):-
    mago(Mago, _),
    corajudo(Mago).
caracterApropiado(Mago, slytherin):-
    mago(Mago, _),
    inteligente(Mago),
    orgulloso(Mago).
caracterApropiado(Mago, ravenclaw):-
    mago(Mago, _),
    inteligente(Mago),
    responsable(Mago).
caracterApropiado(Mago, hufflepuff):-
    mago(Mago, _),
    amistoso(Mago).

puedeQuedar(Mago, Casa):-
    mago(Mago, _),
    casa(Casa),
    puedeEntrar(Mago, Casa),
    caracterApropiado(Mago, Casa),
    not(odia(Mago, Casa)).
puedeQuedar(hermione, gryffindor).

cadenaDeAmistades([Mago,OtroMago]):-
    amistoso(Mago),
    amistoso(OtroMago),
    Mago \= OtroMago,
    puedeQuedar(Mago, Casa),
    puedeQuedar(OtroMago, Casa).
cadenaDeAmistades([Mago,OtroMago|Magos]):-
    amistoso(Mago),
    amistoso(OtroMago),
    Mago \= OtroMago,
    puedeQuedar(Mago, Casa),
    puedeQuedar(OtroMago, Casa),
    cadenaDeAmistades([OtroMago|Magos]).  

/*Definir un predicado ​cadenaDeAmistades/1​ que se cumple para una lista de magos si todos ellos secaracterizan por ser amistosos y cada uno podría estar en la misma casa 
que el siguiente. ​No hace faltaque sea inversible​, se consultará de forma individual.
*/
