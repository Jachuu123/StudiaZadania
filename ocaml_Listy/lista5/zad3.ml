let parens_ok s =
  let char_list = String.to_seq s |> List.of_seq in
  let rec check count chars =
    match chars with
    | [] -> count = 0
    | c :: rest ->
        if c <> '(' && c <> ')' then false
        else if c = '(' then
          check (count + 1) rest
        else
          if count = 0 then false
          else check (count - 1) rest
  in
  check 0 char_list
