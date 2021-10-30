// FnLimpaTexto
// Função Criada por Renato Lira
// Atualizada em 30/10/2021
// Recebe um texto e remove caracteres de controle e espaços em excesso (no início, meio ou fim do texto)

(texto) =>
  let
    Corta = Text.Trim(texto),
    Limpa = Text.Clean(Corta),
    Espaco = Text.Replace(Limpa, "  ", " "),
    Recursividade =
      if Text.Length(Limpa) = Text.Length(Espaco) then
        Espaco
      else
        @FnLimpaTextoCompleto(Espaco)
  in
    Recursividade
