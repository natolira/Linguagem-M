// FnRenomeiaColunasDAXQuery
// Função Criada por Renato Lira  
(tbl as table) as table =>
  let
    NomesColunas  = Table.ColumnNames(tbl), 
    NovosNomes    = List.Transform(NomesColunas, each Text.BetweenDelimiters(_, "[", "]")), 
    ListaRenomear = List.Zip({NomesColunas, NovosNomes}), 
    Renomeado     = Table.RenameColumns(tbl, ListaRenomear)
  in
    Renomeado
