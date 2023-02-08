// FnMultiplicaNiveisHierarquia
// Criada por Renato Lira
// Atualizada em 08/02/2023
//
let
  funcao = (texto as text, optional Separador as nullable text) as table =>
    let
      Fonte = Text.Trim(texto),
      separador = Separador ?? "|",
      Hierarquia = Text.Split(Fonte, separador),
      CriaHierarquia = List.Accumulate(
        Hierarquia,
        {},
        (state, current) => state & {Text.Combine({List.Last(state)} & {current}, separador)}
      ),
      CriaTabela = #table(type table [Nível = text], List.Transform(CriaHierarquia, each {_}))
    in
      CriaTabela,
  documentation = [
    Documentation.Name = " FnMultiplicaNiveisHierarquia ",
    Documentation.Description = "Cria tabela com cada linha dos níveis de hierarquia selecionados",
    Documentation.LongDescription
      = "Retorna uma tabela onde cada linha é um nível de hierarquia selecionado",
    Documentation.Category = " Personalizada ",
    Documentation.Source = " https://github.com/natolira/Linguagem-M ",
    Documentation.Version = " 1.0 ",
    Documentation.Author = " Renato Lira ",
    Documentation.Examples = {
      [
        Description = "  ",
        Code
          = " let
    output = FnMultiplicaNiveisHierarquia(""Brasil|Nordeste|Pernambuco|Recife"", ""|"")
in
    output ",
        Result = "tabela com níveis de hierarquia selecionados: "
          & Text.Combine(funcao("Brasil|Nordeste|Pernambuco|Recife", "|")[Nível], ", ")
      ]
    }
  ]
in
  Value.ReplaceType(funcao, Value.ReplaceMetadata(Value.Type(funcao), documentation))
