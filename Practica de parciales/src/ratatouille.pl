rata(remy, gusteaus).
rata(emile, bar).
rata(django, pizzeria).

cocina(linguini, ratatouille, 3).
cocina(linguini, sopa, 5).
cocina(colette, salmonAsado, 9).
cocina(horst, ensaladaRusa, 8).

trabajaEn(gusteaus, linguini).
trabajaEn(gusteaus, colette).
trabajaEn(gusteaus, skinner).
trabajaEn(gusteaus, horst).
trabajaEn(cafeDes2Moulins, amelie).

%Punto 1
inspeccionSatisfactoria(Restaurante):-
    trabajaEn(Restaurante,_),
    not(rata(_, Restaurante)).

%Punto 2
chef(Empleado, Restaurante):-
    cocina(Empleado,_,_),
    trabajaEn(Restaurante, Empleado).

%Punto 3
chefcito(Rata):-
    trabajaEn(Restaurante, linguini),
    rata(Rata, Restaurante).

%Punto 4
cocinaBien(remy,Plato):-
    cocina(_, Plato, _).
cocinaBien(Cocinero, Plato):-
    cocina(Cocinero, Plato, Experiencia),
    Experiencia > 7.

%Punto 5
encargadoDe(Encargado, Plato, Restaurante):-
    chef(Encargado, Restaurante),
    cocina(Encargado, Plato, ExperienciaEncargado),
    forall((chef(Chef, Restaurante), cocina(Chef, Plato, ExperienciaChef), Encargado \= Chef), ExperienciaEncargado > ExperienciaChef).

%Punto 6
plato(ensaladaRusa, entrada([papa, zanahoria, arvejas, huevo, mayonesa])).
plato(bifeDeChorizo, principal(pure, 20)).
plato(frutillasConCrema, postre(265)).
