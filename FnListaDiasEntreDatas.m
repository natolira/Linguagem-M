// FnListaDiasEntreDatas
// Função Criada por Renato Lira
// Buscar versões atualizadas em: https://github.com/natolira/Linguagem-M
// Última atualização em 31/10/2021
// Transforma entradas no formato date ou datetime em uma tabela que representa a lista de dias contínuo entre as datas

(Inicio, Fim) =>
let
  IdentificaMenor = if Inicio <= Fim then Inicio else Fim,
  IdentificaMaior = if Inicio <= Fim then Fim else Inicio,
  ListaNumerica = {
    Number.From(Date.From(IdentificaMenor)) .. Number.From(Date.From(IdentificaMaior))
  },
  CriaTabela = #table(type table [Data = date], List.Transform(ListaNumerica, each {Date.From(_)}))
in
  CriaTabela
