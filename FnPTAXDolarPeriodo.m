// FnPTAXDolarPeriodo
// Função Criada por Renato Lira
// Buscar versões atualizadas em: https://github.com/natolira/Linguagem-M
// Atualizada em 23/11/2021
// Primeiro Argumento: Data inicial
// Segundo Argumento: Data final
// OBS: Datas antigas podem retornar mais de um valor de cotação em um mesmo dia
// Por isso há um Table.Group para remover o potencial valor duplicado

(datainicial as any, datafinal as any) =>
  let
    Fonte = Json.Document(
      Web.Contents(
        "https://olinda.bcb.gov.br/", 
        [
          RelativePath
            = "olinda/servico/PTAX/versao/v1/odata/CotacaoDolarPeriodo(dataInicial=@dataInicial,dataFinalCotacao=@dataFinalCotacao)", 
          Query = [
            #"@dataInicial"      = Date.ToText(Date.From(datainicial), "\'MM-dd-yyyy\'"), 
            #"@dataFinalCotacao" = Date.ToText(Date.From(datafinal), "\'MM-dd-yyyy\'"), 
            format               = "json"
          ]
        ]
      )
    ), 
    #"value Expandido" = Table.FromRecords(Fonte[value]), 
    #"Tipo Alterado" = Table.TransformColumnTypes(
      #"value Expandido", 
      {{"dataHoraCotacao", type datetime}}
    ), 
    #"Data Inserida" = Table.AddColumn(
      #"Tipo Alterado", 
      "Data", 
      each DateTime.Date([dataHoraCotacao]), 
      type date
    ), 
    #"Linhas Agrupadas" = Table.Group(
      #"Data Inserida", 
      {"Data"}, 
      {
        {
          "Tudo", 
          each _, 
          type table [
            #"@odata.context" = text, 
            Compra = nullable number, 
            Venda = nullable number, 
            DataHora = nullable datetime, 
            Data = date
          ]
        }
      }
    ), 
    MantemValorUnico = Table.TransformColumns(
      #"Linhas Agrupadas", 
      {{"Tudo", each Table.MaxN(_, "dataHoraCotacao", 1), type table}}
    ), 
    #"Tudo Expandido" = Table.ExpandTableColumn(
      MantemValorUnico, 
      "Tudo", 
      {"cotacaoCompra", "cotacaoVenda"}, 
      {"Compra", "Venda"}
    ), 
    #"Tipo Alterado1" = Table.TransformColumnTypes(
      #"Tudo Expandido", 
      {{"Compra", type number}, {"Venda", type number}}
    )
  in
    #"Tipo Alterado1"
