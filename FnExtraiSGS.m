// FnExtraiSGS
// Função Criada por Renato Lira
// Buscar versões atualizadas em: https://github.com/natolira/Linguagem-M
// Atualizada em 23/11/2021
// Primeiro Argumento: número da série do SGS conforme https://www3.bcb.gov.br/sgspub/localizarseries/localizarSeries.do?method=prepararTelaLocalizarSeries
// Segundo Argumento (opcional): data inicial a partir da qual os dados serão retornados
// Terceiro Argumento (opcional):  data final a partir da qual os dados serão retornados
//
// !!! Método não oficial de obtenção de dados sujeito a API throttling 
// Recomendado rodar essa rotina com uso de atualização incremental no Power BI Serviço
// !!! Não rodar essa rotina múltiplas vezes ao dia. Rodar apenas 1x ao dia às 13:30, horário em que o dólar PTAX é divulgado.

(serie, optional inicio, optional fim) as table =>
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
