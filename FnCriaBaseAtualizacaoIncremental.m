// FnCriaBaseAtualizacaoIncremental                                                                                                         
// Função Criada por Renato Lira                                                                                                
// Buscar versões atualizadas em: https://github.com/natolira/Linguagem-M                                                                                                                                                                                                                           
// Atualizada em 03/02/2023                                                                                 
// Primeiro Argumento: Data inicial no formato datetime para atualização incremental                                                                                                                                                                                                                                                            
// Segundo Argumento: Data final no formato datetime para atualização incremental                                                                                                                                                                                                                                                   
// Terceiro Argumento: granularidade (mensal, trimestral, anual, diário)                                                                                                                                                                                                
//      
let
  funcao = (DataInicial as datetime, DataFinal as datetime, optional grao as text) as table =>
    let
      datas = {
        Number.RoundDown(Number.From(DataInicial), 0),
        Number.RoundDown(Number.From(DataFinal), 0) - 1
      },
      menordata = List.Min(datas),
      maiordata = List.Max(datas),
      graoselecionado = Text.Upper(grao) ?? "MENSAL",
      tabelabase = #table(
        type table [Período = date],
        List.Transform({menordata .. maiordata}, each {Date.From(_)})
      ),
      ajustagrao = Table.TransformColumns(
        tabelabase,
        {
          {
            "Período",
            each
              if graoselecionado = "MENSAL" then
                Date.StartOfMonth(_)
              else if graoselecionado = "TRIMESTRAL" then
                Date.StartOfQuarter(_)
              else if graoselecionado = "ANUAL" then
                Date.StartOfYear(_)
              else
                _,
            type date
          }
        }
      ),
      distinto =
        if List.Contains(
          {"ANUAL", "TRIMESTRAL", "MENSAL", "DIÁRIO", "DIARIO", "DIÁRIA", "DIARIA"},
          graoselecionado
        )
        then
          Table.Distinct(ajustagrao)
        else
          error "O tipo do grão: "
            & graoselecionado
            & " não é aceito. Garanta que seja do tip Anual, Trimestral, Mensal ou Diário",
      output = Table.AddColumn(
        Table.AddColumn(distinto, "DUMMY", each DateTime.From(menordata), type datetime),
        "Atualizado em",
        each DateTime.LocalNow(),
        type datetime
      )
    in
      output,
  documentation = [
    Documentation.Name = " FnCriaBaseAtualizacaoIncremental ",
    Documentation.Description = "Cria tabela base para atualizações incrementais",
    Documentation.LongDescription
      = "Retorna uma tabela de períodos com grão pronto de acordo com parâmetros RangeStart e RangeEnd da atualização incremental",
    Documentation.Category = " Personalizada ",
    Documentation.Source = " https://github.com/natolira/Linguagem-M ",
    Documentation.Version = " 1.1 ",
    Documentation.Author = " Renato Lira ",
    Documentation.Examples = {
      [
        Description = "  ",
        Code
          = " let
    RangeStart = #datetime(2022,1,1,0,0,0),
    RangeEnd = #datetime(2023,1,1,0,0,0),
    grao = ""Mensal"",
    ChamarFuncao = 
        FnCriaBaseAtualizacaoIncremental(RangeStart, RangeEnd, grao)
in
    FunctionCall ",
        Result = "Coluna Período com os valores: "
          & Text.Combine(
            List.Transform(
              funcao(#datetime(2022, 1, 1, 0, 0, 0), #datetime(2023, 1, 1, 0, 0, 0), "Mensal")[
                Período
              ],
              each Date.ToText(_, "yyyy-MM-dd")
            ),
            ", "
          )
      ]
    }
  ]
in
  Value.ReplaceType(funcao, Value.ReplaceMetadata(Value.Type(funcao), documentation))
