// FnExtraiSGS
// Função Criada por Renato Lira
// Buscar versões atualizadas em: https://github.com/natolira/Linguagem-M
// Atualizada em 02/11/2021
// Primeiro Argumento: número da série do SGS conforme https://www3.bcb.gov.br/sgspub/localizarseries/localizarSeries.do?method=prepararTelaLocalizarSeries
// Segundo Argumento (opcional): data inicial a partir da qual os dados serão retornados
// Terceiro Argumento (opcional):  data final a partir da qual os dados serão retornados

(serie, inicio, fim) as table =>
  let
    BinarioInteiro = Web.Contents(
      "http://api.bcb.gov.br/",
      [RelativePath = "dados/serie/bcdata.sgs." & Text.From(serie) & "/dados?formato=json"]
    ),
    BinarioPeriodo = Web.Contents(
      "http://api.bcb.gov.br/",
      [
        RelativePath = "dados/serie/bcdata.sgs." & Text.From(serie) & "/dados",
        Query = [
          formato     = "json",
          dataInicial = Date.ToText(Date.From(inicio), "dd/MM/yyyy"),
          dataFinal   = Date.ToText(Date.From(fim), "dd/MM/yyyy")
        ]
      ]
    ),
    Binario = if inicio <> null and fim <> null then BinarioPeriodo else BinarioInteiro,
    AbreJson = try Json.Document(Binario) otherwise Json.Document(BinarioInteiro),
    TransformaTabela = Table.FromRecords(AbreJson),
    #"Tipo Alterado com Localidade" = Table.TransformColumnTypes(
      TransformaTabela,
      {{"data", type text}, {"valor", type number}},
      "en-US"
    )
  in
    #"Tipo Alterado com Localidade"
