// FnLimpaTextoTabela
// Função Criada por Renato Lira
// Buscar versões atualizadas em: https://github.com/natolira/Linguagem-M
// Atualizada em 30/10/2021
// Recebe um uma tabela e remove caracteres de controle e espaços em excesso (no início, meio ou fim do texto) das colunas marcadas como texto
// Segundo argumento opcional com a lista de colunas exclusivas onde deseja realizar a limpeza

(tbl as table, optional lista as list) as table =>
  let
    Colunas = lista ?? Table.ColumnsOfType(tbl, {type text, type nullable text}),
    FnLimpaTexto = (texto) =>
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
        Recursividade,
    Comando = List.Transform(Colunas, each {_, FnLimpaTexto, type text}),
    AplicaLimpeza = Table.TransformColumns(tbl, Comando)
  in
    AplicaLimpeza
