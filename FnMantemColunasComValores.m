// FnMantemColunasComValores
// Função Criada por Renato Lira
// Buscar versões atualizadas em: https://github.com/natolira/Linguagem-M
// Última atualização em 21/01/2022
// A partir de uma tabela (normalmente extraída do Excel) seleciona apenas colunas com valores
// Parâmetro opcional, a partir de quantas linhas com valores manter a coluna
// Parâmetro opcional, escrever qualquer coisa caso queira substituir erros do Excel por null

(tbl as table, optional corte as number, optional TrocaErroPorNull) as table =>
  let
    Tabela = tbl, 
    Corte = corte ?? 0, 
    erro = if TrocaErroPorNull <> null then "sim" else "nao", 
    FnTrocaErroPorValor = (arg) =>
      let
        Fonte                 = arg, 
        Colunas               = Table.ColumnNames(Fonte), 
        Trocas                = List.Transform(Colunas, each {_, null}), 
        #"Erros Substituídos" = Table.ReplaceErrorValues(Fonte, Trocas)
      in
        #"Erros Substituídos", 
    TabelaTratada = if erro = "sim" then FnTrocaErroPorValor(Tabela) else Tabela, 
    ColunasDisponiveis = Table.ColumnNames(TabelaTratada), 
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
      each List.Select(
        Table.Column(TabelaTratada, [Column1]), 
        each try _ <> "" and _ <> null otherwise false
      )
    ), 
    ApenasColunasNaoNulas = Table.SelectRows(
      MantemApenasNaoNulos, 
      each (List.Count([ValoresNaoNulos]) > Corte)
    ), 
    SelecionaColunasNaoNulas = Table.SelectColumns(TabelaTratada, ApenasColunasNaoNulas[Column1])
  in
    SelecionaColunasNaoNulas
