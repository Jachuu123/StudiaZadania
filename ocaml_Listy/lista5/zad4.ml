let parens_ok s =
  let char_list = String.to_seq s |> List.of_seq in
  (* Funkcja sprawdzająca, czy dany nawias otwierający pasuje do nawiasu zamykającego *)
  let matching open_br close_br =
    match (open_br, close_br) with
    | ('(', ')') | ('[', ']') | ('{', '}') -> true
    | _ -> false
  in
  (* Funkcja rekurencyjna, która przetwarza listę znaków przy użyciu stosu *)
  let rec check stack = function
    | [] -> stack = []  (* Na końcu stos musi być pusty *)
    | c :: rest ->
        (* Ignorujemy spacje, aby przykłady z odstępami działały poprawnie *)
        if c = ' ' then check stack rest
        else
          match c with
          | '(' | '[' | '{' ->
              (* Dodajemy nawias otwierający na stos *)
              check (c :: stack) rest
          | ')' | ']' | '}' ->
              (* Gdy pojawia się nawias zamykający, stos nie może być pusty *)
              (match stack with
               | [] -> false
               | top :: tail ->
                   if matching top c then check tail rest
                   else false)
          | _ ->
              (* Inne znaki nie są dozwolone *)
              false
  in
  check [] char_list
