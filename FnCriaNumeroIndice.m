// FnLimpaTexto
// Função Criada por Renato Lira
// Atualizada em 02/11/2021
// Primeiro Argumento: Tabela com coluna ORDENADA por data e números de variações em relação ao período anterior
// Segundo Argumento: nome da coluna com valores de variações em relação ao período anterior
// Terceiro Argumento: Tipo do valor 
//                     (Percentual, ex: 3,48  )
//                     (Numero,     ex: 0,0348)
//                     (Fator,      ex: 1,0348)
// Quarto Argumento (opcional): Nome da nova coluna a ser calculada com o número índice

(tabela as table, colunacomvalores as text, tipovalor as text, optional novacoluna) as table =>
  let
    Fonte = tabela, 
    SelecionaValores = Table.Column(Fonte, colunacomvalores), 
    lista = List.Buffer(
      List.Transform(
        SelecionaValores, 
        each 
          if Text.Upper(tipovalor) = "PERCENTUAL" then
            1 + _ / 100
          else if Text.Upper(tipovalor) = "NUMERO" or Text.Upper(tipovalor) = "NÚMERO" then
            1 + _
          else if Text.Upper(tipovalor) = "FATOR" then
            _
          else
            1
      )
    ), 
    Aux = Table.AddIndexColumn(Fonte, "linha", 1, 1, Int64.Type), 
    CalculaÍndice = Table.AddColumn(
      Aux, 
      novacoluna ?? "Número Índice", 
      each List.Product(List.FirstN(lista, [linha])), 
      type number
    ), 
    Resultado = Table.RemoveColumns(CalculaÍndice, {"linha"})
  in
    Resultado
