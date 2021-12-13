// FnMensalizaDeAte
// Função Criada por Renato Lira
// Buscar versões atualizadas em: https://github.com/natolira/Linguagem-M
// Atualizada em 12/12/2021
// A partir de duas datas de início e término, adiciona uma lista com o número de meses
// e as informações do Período (1o dia de cada mês) e a quantidade de dias no mês entre
// as datas de início e término contidos no mês (período)

(inicio, termino) =>
  let
    De = inicio,  // #datetime(2020,1,15,15,58,0),                                                                                                
    Ate = termino,  // #datetime(2020, 2, 10, 5, 8, 0),                                                                                                         
    ListaMeses = {
      Date.Year(Date.From(De)) * 12 + Date.Month(Date.From(De)) .. Date.Year(Date.From(Ate))
        * 12 + Date.Month(Date.From(Ate))
    },
    ListaInicioDePeriodoMensal = List.Transform(
      ListaMeses,
      each
        let
          inteiro = Number.IntegerDivide(_, 12),
          resto   = Number.Mod(_, 12),
          ano     = if resto = 0 then inteiro - 1 else inteiro,
          mes     = if resto = 0 then 12 else resto,
          dia     = 1,
          data    = #date(ano, mes, dia)
        in
          data
    ),
    AdicionaDuracao = List.Transform(
      ListaInicioDePeriodoMensal,
      each [
        Período = _,
        Dias =
          let
            inferior = if Date.StartOfMonth(Date.From(De)) = _ then De else _,
            superior =
              if Date.StartOfMonth(Date.From(Ate)) = _ then
                Ate
              else
                Date.EndOfMonth(_) + #duration(1, 0, 0, 0),
            dias = Duration.TotalSeconds(DateTime.From(superior) - DateTime.From(inferior))
              / (24 * 60 * 60)
          in
            dias
      ]
    )
  in
    AdicionaDuracao
