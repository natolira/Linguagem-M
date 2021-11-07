// FnRenomeiaColunasDAXQuery
// Função Criada por Renato Lira
// Buscar versões atualizadas em: https://github.com/natolira/Linguagem-M
// Última atualização em 30/10/2021
// Função que renomeia todas as colunas de uma tabela mantendo apenas os valores entre []
// Exemplo: Tabela[Coluna] vira Coluna
(tbl as table) as table =>
  let
    NomesColunas  = Table.ColumnNames(tbl), 
    NovosNomes    = List.Transform(NomesColunas, each Text.BetweenDelimiters(_, "[", "]")), 
    ListaRenomear = List.Zip({NomesColunas, NovosNomes}), 
    Renomeado     = Table.RenameColumns(tbl, ListaRenomear)
  in
    Renomeado
