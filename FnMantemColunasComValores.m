// FnMantemColunasComValores
// Função Criada por Renato Lira
// Última atualização em 07/11/2021
// A partir de uma tabela (normalmente extraída do Excel) seleciona apenas colunas com valores

(tbl as table) as table =>
  let
    Tabela = tbl,
    ColunasDisponiveis = Table.ColumnNames(Tabela),
    ColunasDisponiveisTabela = Table.FromList(
      ColunasDisponiveis,
      Splitter.SplitByNothing(),
      null,
      null,
      ExtraValues.Error
    ),
    MantemApenasNaoNulos = Table.AddColumn(
      ColunasDisponiveisTabela,
      "ValoresNaoNulos",
      each List.Select(Table.Column(Tabela, [Column1]), each _ <> "" and _ <> null)
    ),
    ApenasColunasNaoNulas = Table.SelectRows(
      MantemApenasNaoNulos,
      each (List.Count([ValoresNaoNulos]) > 0)
    ),
    SelecionaColunasNaoNulas = Table.SelectColumns(Tabela, MantemApenasNaoNulos[Column1])
  in
    SelecionaColunasNaoNulas
