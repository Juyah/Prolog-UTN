mensaje(['hola', ',', 'qué', 'onda', '?'], nico).
mensaje(['todo', 'bien', 'dsp', 'hablamos'], nico).
mensaje(['q', 'parcial', 'vamos', 'a', 'tomar', '?'], [nico, lucas, maiu]).
mensaje(['todo', 'bn', 'dsp', 'hablamos'], [nico, lucas, maiu]).
mensaje(['todo', 'bien', 'después', 'hablamos'], mama).
mensaje(['¿','y','q', 'onda', 'el','parcial', '?'], nico).
mensaje(['¿','y','qué', 'onda', 'el','parcial', '?'], lucas).
mensaje(['¿','y','qué', 'onda', 'el','parcial', '?'], lucas).

abreviatura('dsp', 'después').
abreviatura('q', 'que').
abreviatura('q', 'qué').
abreviatura('bn', 'bien').

signo('¿'). 
signo('?'). 
signo('.'). 
signo(',').

filtro(nico, masDe(0.5)).
filtro(nico, ignorar(['interestelar'])).
filtro(lucas, masDe(0.7)).
filtro(lucas, soloFormal).
filtro(mama, ignorar(['dsp','paja'])).

%Punto 1
recibioMensaje(Persona, Mensaje):-
    mensaje(Mensaje,Persona),
    not(member(_, Persona)).
recibioMensaje(Persona, Mensaje):-
    mensaje(Mensaje, Personas),
    member(Persona, Personas).

%Punto 2
demasiadoFormal(Mensaje):-
    dimensionMensaje(Mensaje, Dimension),
    Dimension > 20,
    incluyeSignos(Mensaje),
    comienzaConPregunta(Mensaje),
    not(tieneAbreviaturas(Mensaje)).

dimensionMensaje(Mensaje, Dimension):-
    mensaje(Mensaje,_),
    length(Mensaje, Dimension).

incluyeSignos(Mensaje):-
    signo(Signo),
    member(Signo, Mensaje).

comienzaConPregunta(['¿'|_]).

tieneAbreviaturas(Mensaje):-
    abreviatura(Abreviatura,_),
    member(Abreviatura, Mensaje).

%Punto 3
esAceptable(Palabra, Persona):-
    recibioMensaje(Persona,_),
    forall(filtro(Persona, TipoFiltro),cumpleFiltro(Persona, Palabra, TipoFiltro)).

cumpleFiltro(Persona, Palabra, masDe(N)):-
    tasaDeUso(Palabra, Persona, Tasa),
    Tasa > N.
cumpleFiltro(_, Palabra, ignorar(Palabras)):-
    not(member(Palabra, Palabras)).
cumpleFiltro(Persona, Palabra, soloFormal):-
    recibioMensaje(Persona, Mensaje),
    demasiadoFormal(Mensaje),
    member(Palabra, Mensaje).

tasaDeUso(Palabra, Persona, Tasa):-
    usoUsual(Palabra, Persona, UsoPersona),
    usoUsual(Palabra, _, UsoTotal),
    Tasa is UsoPersona / UsoTotal.

usoUsual(Palabra, Persona, Uso):-
    findall(Palabra,(recibioMensaje(Persona, Mensaje), member(Palabra, Mensaje)), Palabras),
    length(Palabras, Uso).


%Punto 4
dicenLoMismo(Mensaje, OtroMensaje):-
    mensaje(Mensaje,_),
    mensaje(OtroMensaje,_),
    mismaLongitud(Mensaje, OtroMensaje),
    forall((nth1(Index, Mensaje, Palabra), nth1(Index, OtroMensaje, OtraPalabra)), palabraSimilar(Palabra, OtraPalabra)).  

mismaLongitud(Mensaje, OtroMensaje):-
    length(Mensaje, Longitud),
    length(OtroMensaje, Longitud).

palabraSimilar(Palabra, Palabra).
palabraSimilar(Palabra, OtraPalabra):-
    abreviatura(Palabra, OtraPalabra).
palabraSimilar(Palabra, OtraPalabra):-
    abreviatura(OtraPalabra, Palabra).

%Punto 5
esPersona(Persona):-
    distinct(Persona,recibioMensaje(Persona, _)).
fraseCelebre(Mensaje):-
    recibioMensaje(_,Mensaje),
    %not((esPersona(Persona), not(recibioMensajeSimilar(Persona, Mensaje)))).
    forall(esPersona(Persona), recibioMensajeSimilar(Persona, Mensaje)).

recibioMensajeSimilar(Persona, Mensaje):-
recibioMensaje(Persona, OtroMensaje), 
dicenLoMismo(Mensaje, OtroMensaje).

%Punto 6
prediccion(Mensaje, Receptor, Prediccion):-
    