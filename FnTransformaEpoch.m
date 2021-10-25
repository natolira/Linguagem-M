// FnTransformaEpoch
// Função Criada por Renato Lira
(Data as date) => 
let
    Fonte = #datetime(1970, 1, 1, 0, 0, 0),
    Duracao = DateTime.From(Data) - Fonte,
    TransformaSegundos = Duration.TotalSeconds(Duracao),
    FormatoTexto = Text.From(TransformaSegundos)
in
    FormatoTexto
