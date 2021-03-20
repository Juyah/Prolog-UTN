/*
Declará en este archivo tus predicados y dejá comentarios multilínea
con los ejemplos de uso luego de cada punto y justificaciones que correspondan.
*/

%tripulante(Nombre, Rol, Pais).
tripulante(robert, capitan, inglaterra).
tripulante(martin, asistenteDe(capitan), inglaterra).
%tripulante(martin, asistenteCapitan, inglaterra). 
tripulante(lewis, maestre, francia).
tripulante(robin, maestre, canada).
tripulante(richard, asistenteDe(maestre), inglaterra).
tripulante(john, asistenteDe(maestre), inglaterra).
%tripulante(richard, asistenteMaestre, inglaterra). 
%tripulante(john, asistenteMaestre, inglaterra). 
tripulante(oliver, marinero([vigilar, timonear]), inglaterra).
tripulante(george, marinero([izarVelas, vigilar]), inglaterra).
tripulante(charles, marinero([limpiar, izarVelas]), inglaterra).
tripulante(beng, pasajero, chino).
tripulante(lim, pasajero, chino).
tripulante(thomas, cocinero, inglaterra).

%asesinato(Asesino, Victima).
asesinato(george, richard).
asesinato(george, martin).
asesinato(george, oliver).
asesinato(lewis, beng).
asesinato(charles, lewis).
asesinato(lewis, robin).
asesinato(john, george).
asesinato(richard, charles).
asesinato(richard, lim).


/*
1. Cuántos tripulantes asesinados hubieron en la catástrofe de cada país.

Justificación: Utilice findall para realizar una lista de aquellos tripulantes asesinados, luego realizando un length para conocer la cantidad de los mismos.
*/

asesinatosPais(Pais, Cantidad):-
    esPais(Pais),
    findall(Tripulante, (esVictima(Tripulante), nacionalidad(Tripulante, Pais)), Tripulantes),
    length(Tripulantes, Cantidad).

esPais(Pais):-
    tripulante(_, _, Pais).

esVictima(Victima):-
    asesinato(_, Victima).

nacionalidad(Tripulante, Pais):-
tripulante(Tripulante, _, Pais).

/*
2. Qué países tuvieron un fin sangriento, que son aquellos para los cuales todos los tripulantes de ese país fueron asesinados.

Justificación: Se utilizo un forall porque es mas representativo de lo que se quiere llevar acabo. 
Para todo tripulante DEL pais (Pues esta definido anteriormente, no dejandolo libre, sino seria que TODOS los paises que existen), se cumple que
fue asesinado. Realizarlo con el not, no es tan expresivo como se puede observar y no da a entender facilmente el planteamiento. 
*/

paisSangriento(Pais):-
    esPais(Pais),
    forall(nacionalidad(Tripulante, Pais), esVictima(Tripulante)).
    %not((nacionalidad(Tripulante, Pais), not(esVictima(Tripulante)))).

/*
3. Si dos tripulantes son cercanos, lo cual depende exclusivamente de sus roles, por las interacciones que se daban en el barco. 
Sabemos que los asistentes interactúan con los que deben asistir, también se dan interacciones al desempeñar un mismo rol, y los cocineros interactúan con todos. 
En el caso de los marineros, interactúan si realizan al menos una tarea en común.

Justificación: Realize la interaccion en un predicado aparte que es polimorfico, tanto para la futura creación de nuevos roles, como la expersividad y la no repetición de logica.
*/

sonCercanos(Tripulante, OtroTripulante):-
    rolAsignado(Tripulante, Rol),
    rolAsignado(OtroTripulante, OtroRol),
    Tripulante \= OtroTripulante,
    interactuan(Rol, OtroRol).

rolAsignado(Tripulante, Rol):-
    tripulante(Tripulante,Rol,_).

interactuan(Rol, asistenteDe(Rol)).
interactuan(asistenteDe(Rol), Rol).
interactuan(Rol, Rol).
interactuan(marinero(Lista),marinero(OtraLista)):-
    tienenElementoComun(Lista, OtraLista).
interactuan(cocinero, _).
interactuan(_, cocinero).

tienenElementoComun(Lista, OtraLista):-
    member(Elemento, Lista),
    member(Elemento, OtraLista).

/*
4. Qué tripulantes son inocentes; esto significa que no mataron a nadie que no fuese un traidor. Un traidor es alguien que mató a un tripulante cercano a sí mismo.

Justificación: Nuevamente usamos un forall por la gran expresividad que lleva, comparado con la negación. Se lee que para todo asesinato DEL tripulante, ese asesintao fue hecho a un traidor.
*/

esInocente(Tripulante):-
    esTripulante(Tripulante),
    forall(asesinato(Tripulante, OtroTripulante), esTraidor(OtroTripulante)).
    %not((asesinato(Tripulante, OtroTripulante), not(esTraidor(OtroTripulante)))).

esTraidor(Tripulante):-
    asesinato(Tripulante, OtroTripulante),
    sonCercanos(Tripulante, OtroTripulante).

esTripulante(Tripulante):-
    tripulante(Tripulante,_,_).
/*
5. Para desentramar el misterio, tenemos que considerar las muertes que fueron por venganza. 
En una venganza intervienen 3 tripulantes: un vengador, un vengado y el blanco de la venganza (o sea, a quién mató el vengador). 
Para que se considere venganza, el blanco de la venganza debe haber matado al vengado y el vengador al blanco de la venganza. Además el vengado y el vengador deben ser cercanos.

Justificación: Utilizamos el predicado sonCercanos para no repetir la logica.
*/

muerteVenganza(Vengador, Vengado, Asesinado):-
    asesinato(Asesinado, Vengado),
    asesinato(Vengador, Asesinado),
    sonCercanos(Vengador, Vengado).

/*
6. Nuestro informe va a llegar a las autoridades de los países involucrados, por lo que nos pidieron que reportemos si un país fue honorable,
que se cumple si no hubo ningún traidor de ese país. Inglaterra aparezca como un país honorable

Justificación: En este predicado estoy conforme tanto con el forall como el not, la lectura se hace sencilla en ambas partes y la expresividad no se pierde.
Para todo tripulante DEL pais, se cumple que no es traidor ese tripulante.
No existe un pais que tenga un tripulante traidor.
*/

paisHonorable(inglaterra).
paisHonorable(Pais):-
    esPais(Pais),
    forall(nacionalidad(Tripulante, Pais), not(esTraidor(Tripulante))).
    %not((nacionalidad(Tripulante, Pais), esTraidor(Tripulante))).

/*
7. Motín! Motín! El último acto que supimos del barco fue un motín. 
Nos gustaría saber si un tripulante formó parte del motín: esto se cumple cuando el tripulante mató o es cercano a alguien que haya matado a alguien que esté al mando. 
Un tripulante está al mando si desempeña el rol de capitán o de asistente de capitán.

Justificación: Estar al mando y tener un rol de mando, luego del planteamiento de los tutores, lo hice separado para poder hacer el polimorfismo en caso de que haya otro nuevo rol que este al mando.
por lo tanto estar al mando depende de si el rol que tiene es un rol de mando. 
*/

parteMotin(Tripulante):-
    matoAlMando(Tripulante).
parteMotin(Tripulante) :-
    sonCercanos(Tripulante, OtroTripulante),
    matoAlMando(OtroTripulante).

matoAlMando(Tripulante):-
    asesinato(Tripulante, Mando),
    estaAlMando(Mando).

estaAlMando(Tripulante):-
    rolAsignado(Tripulante, Rol),
    esRolMando(Rol).

esRolMando(capitan).
esRolMando(asistenteDe(capitan)).


/*
8. Desarrollar un predicado transitivo que relacione a un vengador con cada uno de sus causales de venganza, 
es decir, con aquellos que directa o indirectamente lo convirtieron en un vengador. 
Dado un vengador, el causal de venganza directo es el blanco de su venganza, y si ese blanco a su vez era un vengador, los causales de venganza de su blanco son causales 
indirectos del vengador en cuestión. Por ejemplo, si ocurrió lo siguiente: 
Richard se vengó de Charles por haber matado a Lewis.
George se vengó de Richard por haber matado a Charles.
John se vengó de George por haber matado a Richard.

Justificación: Utilice la recursividad para los causales de venganza.
*/

causalesVenganza(Vengador, Causales):- %Forma de verlo en lista.
    esVengador(Vengador),
    findall(Causal, causalVeganza(Vengador, Causal), Causales).

esVengador(Tripulante):- %Parte de forma de verlo en lista.
    muerteVenganza(Tripulante, _, _).

causalVeganza(Vengador, Causal):-
    muerteVenganza(Vengador, _, Asesinado),
    causalVeganza(Asesinado, Causal).

causalVeganza(Vengador, Asesinado):-
    muerteVenganza(Vengador, _, Asesinado).

/*
9. En caso de haber predicados auxiliares no inversibles, indicar para cada uno de ellos cuál es la causa de no inversibilidad y por qué se elige no hacerlo inversible.
Explicar las decisiones tomadas relativas al modelado de información.

a.
tienenElementoComun(Lista, OtraLista).
Es un predicado general, el cual analiza si dos listas tienen al menos un elemento en comun. Pues como es general analiza 2 listas sin elementos especificos.

interactuan(X,Y).
No es un predicado inversible porque lo hicimos polimorfico no inversible.

interactuan(azucar, azucar), Rol = azucar y esto sera verdadero, pues es verdadero a todo elemento igual haciendo que la inversibilidad no exista.
interactuan(asistenteDe(azucar), azucar).
Para la parte de marinero analizara simplemente listas.
Para el rol de cocinero es compatible con cualquier cosa, por el '_'.

No es necesario realizar este predicado inversible, pues lo que queremos es que sea polimorfico al rol.
Cuando este predicado se usa, se analiza previamente que corresponda a un rol, pues eso sucede en sonCercanos.
*/