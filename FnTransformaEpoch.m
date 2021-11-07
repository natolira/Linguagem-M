// FnTransformaEpoch
// Função Criada por Renato Lira
// Buscar versões atualizadas em: https://github.com/natolira/Linguagem-M
// Última atualização em 30/10/2021
// Transforma uma entrada no formato date ou datetime no formado de data/hora Epoch no formato texto
// Utilizado no WebScrapping do Yahoo Finance
(Data) as text =>
  let
    Fonte              = #datetime(1970, 1, 1, 0, 0, 0), 
    Duracao            = DateTime.From(Data) - Fonte, 
    TransformaSegundos = Duration.TotalSeconds(Duracao), 
    FormatoTexto       = Text.From(TransformaSegundos)
  in
    FormatoTexto
