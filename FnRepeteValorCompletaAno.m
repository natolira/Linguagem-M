// FnRepeteValorCompletaAno                           
// Função Criada por Renato Lira                                
// Buscar versões atualizadas em: https://github.com/natolira/Linguagem-M                                                                         
// Atualizada em 09/11/2021                           
// Primeiro Argumento: Tabela com coluna de data a ser completado até dezembro do último valor                                                                                              
// Segundo Argumento (opcional): Completar de forma "mensal" ou "diária"                                                                        
// Terceiro Argumento (opcional): Nome da coluna de data no seu modelo                                                                      
(tbl as table, optional Forma as text, optional Data as text) as table =>
  let
    data = Data ?? "Data",
    forma = Forma ?? "Mensal",
    Fonte = tbl,
    Repetir = Table.Last(Table.Buffer(Table.Sort(Fonte, {{data, Order.Ascending}}))),
    CompletaAno = List.Generate(
      () => Record.AddField(Repetir, "Ano", Date.Year(Record.Field(Repetir, data))),
      each Date.Year(Record.Field(_, data)) = [Ano],
      each Record.TransformFields(
        _,
        {
          {
            data,
            each
              if Text.Upper(forma) = "DIÁRIA" or Text.Upper(forma) = "DIARIA" then
                Date.AddDays(_, 1)
              else
                Date.AddMonths(_, 1)
          }
        }
      ),
      each Record.RemoveFields(_, "Ano")
    ),
    RemoveDuplicata = List.Skip(CompletaAno),
    #"Transforma Tabela" = Table.FromRecords(Table.ToRecords(Fonte) & RemoveDuplicata)
  in
    #"Transforma Tabela"
