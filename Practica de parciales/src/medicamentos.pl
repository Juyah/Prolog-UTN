vende(laGondoriana,trancosin,35).
vende(laGondoriana,sanaSam,35).

incluye(trancosin,athelas).
incluye(trancosin,cenizaBoromireana).

efecto(athelas,cura(desazon)).
efecto(athelas,cura(heridaDeOrco)).
efecto(cenizaBoromireana,cura(gripeA)).
efecto(cenizaBoromireana,potencia(deseoDePoder)).

estaEnfermo(eomer,heridaDeOrco). % eomer es varon
estaEnfermo(eomer,deseoDePoder).
estaEnfermo(eomund,desazon).
estaEnfermo(eowyn,heridaDeOrco). % eowyn es mujer

padre(eomund,eomer).

actividad(eomer,fecha(15,6,3014),compro(trancosin,laGondoriana)).
actividad(eomer,fecha(15,8,3014),preguntoPor(sanaSam,laGondoriana)).
actividad(eowyn,fecha(14,9,3014),preguntoPor(sanaSam,laGondoriana)).

%Punto 1
medicamentoUtil(Persona, Medicamento):-
    estaEnfermo(Persona, Enfermedad),
    loCura(Medicamento, Enfermedad),
    not((estaEnfermo(Persona, OtraEnfermedad),loPotencia(Medicamento, OtraEnfermedad))).

loCura(Medicamento, Enfermedad):-
    incluye(Medicamento, Droga),
    efecto(Droga, cura(Enfermedad)).

loPotencia(Medicamento, Enfermedad):-
    incluye(Medicamento, Droga),
    efecto(Droga, potencia(Enfermedad)).

%Punto 2
medicamentoMilagroso(Persona, Medicamento):-
    esPersona(Persona), esMedicamento(Medicamento),
    forall(estaEnfermo(Persona, Enfermedad), (loCura(Medicamento, Enfermedad), not(loPotencia(Medicamento, Enfermedad)))).

esPersona(Persona):-
    estaEnfermo(Persona,_).

esMedicamento(Medicamento):-
    incluye(Medicamento,_).

%Punto 3
drogaSimpatica(Droga):-
    esDroga(Droga),
    cantEnfermedadesCura(Droga, Cantidad),
    Cantidad >= 4,
    not(efecto(Droga, potencia(_))).

drogaSimpatica(Droga):-
    estaEnfermo(eomer, Enfermedad),
    estaEnfermo(eowyn, OtraEnfermedad),
    Enfermedad \= OtraEnfermedad,
    efecto(Droga,cura(Enfermedad)),
    efecto(Droga,cura(OtraEnfermedad)).

drogaSimpatica(Droga):-
    incluye(Medicamento, Droga),
    seVende(Medicamento),
    not((vende(_, Medicamento, Precio), Precio > 10)).

esDroga(Droga):-
    efecto(Droga,_).

cantEnfermedadesCura(Droga, CantidadEnfermedades):-
    findall(Enfermedad, efecto(Droga, cura(Enfermedad)), Enfermedades),
    length(Enfermedades, CantidadEnfermedades).

seVende(Medicamento):-
vende(_, Medicamento, _).

%Punto 4
tipoSuicida(Persona):-
    compro(Persona, Medicamento),

compro(Persona, Medicamento):-
    actividad(Persona,_,compro(Medicamento,_)).