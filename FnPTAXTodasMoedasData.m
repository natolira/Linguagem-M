// FnPTAXTodasMoedasData
// Função Criada por Renato Lira
// Buscar versões atualizadas em: https://github.com/natolira/Linguagem-M                          
// Última atualização em 31/10/2021
// Função que retorna valores extraídos do BACEN com cotações para BRL e USD compatíves com PTAX

(data) as table =>           
let
  Fonte = Csv.Document(
    Web.Contents(
      "https://www4.bcb.gov.br/",
      [RelativePath = "Download/fechamento/" & Date.ToText(Date.From(data), "yyyyMMdd") & ".csv"]
    ),
    [Delimiter = ";", Columns = 8, Encoding = 1252, QuoteStyle = QuoteStyle.None]
  ),
  #"Tipo Alterado" = Table.TransformColumnTypes(
    Fonte,
    {
      {"Column1", type date},
      {"Column2", type text},
      {"Column3", type text},
      {"Column4", type text},
      {"Column5", type number},
      {"Column6", type number},
      {"Column7", type number},
      {"Column8", type number}
    }
  ),
  #"Colunas Renomeadas" = Table.RenameColumns(
    #"Tipo Alterado",
    {
      {"Column1", "Data"},
      {"Column2", "Cod Moeda"},
      {"Column3", "Tipo"},
      {"Column4", "Moeda"},
      {"Column5", "BRL Compra"},
      {"Column6", "BRL Venda"},
      {"Column7", "Paridade Compra"},
      {"Column8", "Paridade Venda"}
    }
  ),
  #"Linhas Filtradas" = Table.SelectRows(
    #"Colunas Renomeadas",
    each ([BRL Compra] <> null) and ([Moeda] <> "XAU")
  ),
  #"Personalização Adicionada" = Table.AddColumn(
    #"Linhas Filtradas",
    "USD Compra",
    each if [Tipo] = "B" then [Paridade Compra] else 1 / [Paridade Compra],
    type number
  ),
  #"Personalização Adicionada1" = Table.AddColumn(
    #"Personalização Adicionada",
    "USD Venda",
    each if [Tipo] = "B" then [Paridade Venda] else 1 / [Paridade Venda],
    type number
  ),
  #"Outras Colunas Removidas" = Table.SelectColumns(
    #"Personalização Adicionada1",
    {"Data", "Cod Moeda", "Moeda", "BRL Compra", "BRL Venda", "USD Compra", "USD Venda"}
  )
in
  #"Outras Colunas Removidas"
