let parens_ok s =
  (* Konwersja napisu na listę znaków *)
  let char_list = String.to_seq s |> List.of_seq in
  (* Funkcja pomocnicza: count – aktualny stan otwartych nawiasów,
     chars – przetwarzana lista znaków *)
  let rec check count chars =
    match chars with
    | [] -> count = 0  (* Na końcu musimy mieć równowagę 0 *)
    | c :: rest ->
        (* Jeśli znak nie jest ani '(' ani ')', zwracamy false *)
        if c <> '(' && c <> ')' then false
        else if c = '(' then
          check (count + 1) rest
        else (* c = ')' *)
          if count = 0 then false (* Nie można zamknąć nawiasu, jeśli żaden nie jest otwarty *)
          else check (count - 1) rest
  in
  check 0 char_list
