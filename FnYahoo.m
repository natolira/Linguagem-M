// FnYahoo
// Função Criada por Renato Lira
// Buscar versões atualizadas em: https://github.com/natolira/Linguagem-M                           
// Última atualização em 30/10/2021
// Função que retorna valores extraídos do Yahoo Finance de um ticker para um período de datas
// !!! Método não oficial de obtenção de dados sujeito a API throttling 
// Recomendado rodar essa rotina com uso de atualização incremental no Power BI Serviço
// !!! Não rodar essa rotina múltiplas vezes ao dia. Rodar apenas 1x ao dia após o fechamento dos mercados.

(Ticker as text, DataInicial as date, DataFinal as date) as table =>
  let
    FnTransformaEpoch = (Data as date) =>
      let
        Fonte              = #datetime(1970, 1, 1, 0, 0, 0), 
        Duracao            = DateTime.From(Data) - Fonte + #duration(0, 23, 59, 59),  // completa caso dia esteja incompleto                                                                                                   
        TransformaSegundos = Duration.TotalSeconds(Duracao), 
        FormatoTexto       = Text.From(TransformaSegundos)
      in
        FormatoTexto, 
    Fonte = Csv.Document(
      Web.Contents(
        "https://query1.finance.yahoo.com/v7/finance/download/", 
        [
          RelativePath = Ticker, 
          Query = [
            period1              = FnTransformaEpoch(DataInicial), 
            period2              = FnTransformaEpoch(DataFinal), 
            interval             = "1d", 
            events               = "history", 
            includeAdjustedClose = "true"
          ]
        ]
      ), 
      [Delimiter = ",", Columns = 7, Encoding = 1252, QuoteStyle = QuoteStyle.None]
    ), 
    #"Cabeçalhos Promovidos" = Table.PromoteHeaders(Fonte, [PromoteAllScalars = true]), 
    #"Tipo Alterado com Localidade" = Table.TransformColumnTypes(
      #"Cabeçalhos Promovidos", 
      {
        {"Open", type number}, 
        {"High", type number}, 
        {"Low", type number}, 
        {"Close", type number}, 
        {"Adj Close", type number}, 
        {"Volume", type number}
      }, 
      "en-US"
    ), 
    #"Tipo Alterado" = Table.TransformColumnTypes(
      #"Tipo Alterado com Localidade", 
      {{"Date", type date}}
    ), 
    #"Linhas Filtradas" = Table.SelectRows(#"Tipo Alterado", each [Open] <> null and [Open] <> "")
  in
    #"Linhas Filtradas"
