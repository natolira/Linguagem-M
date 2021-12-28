// FnComparaBases
// Função Criada por Renato Lira
// Buscar versões atualizadas em: https://github.com/natolira/Linguagem-M
// Atualizada em 28/12/2021
// Primeiro Argumento: Tabela com valor considerdado Gabarito para validação
// Segundo Argumento: Tabela com valor que se gostaria validar
// Terceiro Argumento: Colunas de valores a serem subtraídas para comparação
// Quarto Argumento: Colunas de valores que definem a granularidade da comparação
//
// OBS: Os nomes das colunas envolvidas no quarto argumento (granularidade) devem
// ser idênticos nas tabelas do primeiro e segundo argumento

(gabarito as table, aValidar as table, ListaCalculaDeltaEm as list, ListaAgruparPor as list) as table =>
  let
    CalculaDeltaEm = ListaCalculaDeltaEm,
    AgruparPor = ListaAgruparPor,
    ValoresOficiais = gabarito,
    ValoresASeremValidados = aValidar,
    checkDistintos = List.Intersect({CalculaDeltaEm, AgruparPor}),
    colunasASeremUtilizadas = List.Distinct(CalculaDeltaEm & AgruparPor),
    ColunasNasTabelas = List.Intersect(
      {
        Table.ColumnNames(ValoresOficiais),
        Table.ColumnNames(ValoresASeremValidados),
        colunasASeremUtilizadas
      }
    ),
    ListaAjustaSinal = List.Transform(CalculaDeltaEm, each {_, each - 1 * _, type number}),
    AjustaSinal = Table.TransformColumns(ValoresASeremValidados, ListaAjustaSinal),
    Personalizar1 = Table.Combine({ValoresOficiais, AjustaSinal}),
    ListaAgrupar = List.Transform(
      CalculaDeltaEm,
      each
        let
          delta = _
        in
          {delta, each List.Sum(Record.Field(_, delta)), type number}
    ),
    #"Linhas Agrupadas" = Table.Group(
      Personalizar1,
      AgruparPor,
      ListaAgrupar & {{"Tudo", each _, type table}}
    ),
    #"Linhas Filtradas" = Table.SelectRows(
      #"Linhas Agrupadas",
      each
        let
          delta = _
        in
          Number.Abs(List.Sum(List.Transform(CalculaDeltaEm, each Record.Field(delta, _)))) >= 0.01
    ),
    #"Colunas Renomeadas" =
      if List.NonNullCount(checkDistintos)
        = 0 and List.NonNullCount(colunasASeremUtilizadas)
        = List.NonNullCount(ColunasNasTabelas)
      then
        Table.RenameColumns(
          #"Linhas Filtradas",
          List.Transform(CalculaDeltaEm, each {_, "DELTA-" & _})
        )
      else
        error
          if List.NonNullCount(checkDistintos) > 0 then
            "Selecione colunas a calcular o delta e agrupar por sem interseção"
          else
            "As tabelas fornecidas devem possuir todas as colunas agrupar por e calcula delta em"
  in
    #"Colunas Renomeadas"
