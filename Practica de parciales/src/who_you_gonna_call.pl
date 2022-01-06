herramientasRequeridas(ordenarCuarto, [aspiradora(100), trapeador, plumero]).
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordedadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradpesora, cera, aspiradora(300)]).

%Punto 1
tiene(egon, aspiradora(200)).
tiene(egon, trapeador).
tiene(peter, trapeador).
tiene(winston, varitaDeNeutrones).

%Punto 2
satisfaceHerramientaRequerida(Integrante, Herramienta):-
    tiene(Integrante, Herramienta),
    Herramienta \= aspiradora(_).
satisfaceHerramientaRequerida(Integrante, aspiradora(PotenciaRequerida)):-
    tiene(Integrante, aspiradora(Potencia)),
    Potencia >= PotenciaRequerida. %NO INVERSIBLE
    %between(0, Potencia, PotenciaRequerida). Inversible
    

%Punto 3
realizarTarea(Integrante, Tarea):-
    tiene(Integrante,_),
    herramientasRequeridas(Tarea, Herramientas),
    forall(member(Herramienta, Herramientas), satisfaceHerramientaRequerida(Integrante, Herramienta)).
realizarTarea(Integrante, Tarea):-
    herramientasRequeridas(Tarea, _),
    tiene(Integrante, varitaDeNeutrones).

%Punto 4
%tareaPedida(tarea, cliente, metrosCuadrados).
tareaPedida(ordenarCuarto, dana, 20).
tareaPedida(cortarPasto, walter, 50).
tareaPedida(limpiarTecho, walter, 70).
tareaPedida(limpiarBanio, louis, 15).

%precio(tarea, precioPorMetroCuadrado).
precio(ordenarCuarto, 13).
precio(limpiarTecho, 20).
precio(limpiarBanio, 55).
precio(cortarPasto, 10).
precio(encerarPisos, 7).

cobrarCliente(Cliente, Pagar):-
    tareaPedida(_,Cliente,_),
    findall(Precio, tareasHacer(Cliente, Precio), Precios),
    sumlist(Precios, Pagar).
    
tareasHacer(Cliente, Precio):-
    tareaPedida(Tarea, Cliente, Metros),
    precio(Tarea, XMetro),
    Precio is Metros * XMetro.

%Punto 5
aceptaElPedido(Integrante, Cliente):-
    tiene(Integrante,_),
    tareaPedida(_,Cliente,_),
    forall(tareaPedida(Tarea, Cliente, _), realizarTarea(Integrante, Tarea)),
    estaDispuesto(Integrante, Cliente).

estaDispuesto(winston, Cliente):-
    cobrarCliente(Cliente, Pagar),
    Pagar > 500.

estaDispuesto(egon, Cliente):-
    forall(tareaPedida(Tarea, Cliente, _), not(tareaCompleja(Tarea))).

tareaCompleja(Tarea):-
    herramientasRequeridas(Tarea, Lista),
    length(Lista, 1).
tareaCompleja(limpiarTecho).

estaDispuesto(peter, _).

estaDispuestoAHacer(ray, Cliente):-
	not(tareaPedida(limpiarTecho, Cliente, _)).

%Punto 6
/* Lo que se podría hacer es una lista dentro de la lista, donde por ejemplo:
Si para las aspiradora puedo usar una escoba yo tendría [escoba, aspiradora(X)].
Haciendo esto debemos de modificar el predicado satisfaceHerramientaRequerida, donde ahora
tambien puede recibir una lista. Y si tiene alguno de los elementos que esta en esa lista, entonces satisface.
Por lo tanto seria un member(Herramienta, HerramientaAlternativas), y que esa Herramienta la tenga la persona, por lo tanto
seria llamar devuelta a satisfaceHerramientaRequerida pues puede ser tanto una aspiradora como no.
*/
satisfaceHerramientaRequerida(Integrante, Alternativas):-
    member(Herramienta, Alternativas),
    satisfaceHerramientaRequerida(Integrante, Herramienta).
%No entraria en recursividad pues Alternativas acepta listas por el member.

%Su facilidad se debe a que realizamos la accion de realizar una tarea separada de tener una herramienta necesaria.
