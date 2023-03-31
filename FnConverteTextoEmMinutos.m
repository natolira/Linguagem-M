// FnConverteTextoEmMinutos
// Função Criada por Renato Lira
// Buscar versões atualizadas em: https://github.com/natolira/Linguagem-M
// Atualizada em 31/03/2023
// Aceita texto por extenso, ex: 2 dias 20 horas 1 minuto
// e transforma na respectica quantidade em minutos
(texto as text) as number =>
let
    Fonte = Text.Trim(texto),
    TransformaEmLista = Text.Split(Fonte, " "),
    removeS = List.ReplaceValue(TransformaEmLista, "s", "",  Replacer.ReplaceText),
    Maiuscula = List.Transform( removeS, each Text.Upper(_)),
    CriaRegistro = Record.FromList( List.Alternate(Maiuscula, 1, 1, 1), List.Alternate(Maiuscula, 1, 1)),
    ResultadoEmMinutos = Number.From(try CriaRegistro[EGUNDO] otherwise 0)/60 + Number.From(try CriaRegistro[MINUTO] otherwise 0) + Number.From(try CriaRegistro[HORA] otherwise 0)*60 + Number.From(try CriaRegistro[DIA] otherwise 0)*60*24 + Number.From(try CriaRegistro[EMANA] otherwise 0)*60*24*7
in
    ResultadoEmMinutos
