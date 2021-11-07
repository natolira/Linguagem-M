// FnLimpaTexto
// Função Criada por Renato Lira
// Buscar versões atualizadas em: https://github.com/natolira/Linguagem-M
// Atualizada em 30/10/2021
// Recebe um texto e remove caracteres de controle e espaços em excesso (no início, meio ou fim do texto)
// Importante! Devido à recursividade, é necessário que o nome da consulta seja o mesmo: FnLimpaTexto 

(texto) =>
  let
    Corta = Text.Trim(texto),
    Limpa = Text.Clean(Corta),
    Espaco = Text.Replace(Limpa, "  ", " "),
    Recursividade =
      if Text.Length(Limpa) = Text.Length(Espaco) then
        Espaco
      else
        @FnLimpaTexto(Espaco)
  in
    Recursividade
