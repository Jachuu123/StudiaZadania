let parens_ok s =
  let char_list = String.to_seq s |> List.of_seq in
  let matching open_br close_br =
    match (open_br, close_br) with
    | ('(', ')') | ('[', ']') | ('{', '}') -> true
    | _ -> false
  in
  let rec check stack = function
    | [] -> stack = []
    | c :: rest ->
        if c = ' ' then check stack rest
        else
          match c with
          | '(' | '[' | '{' -> check (c :: stack) rest
          | ')' | ']' | '}' ->
              (match stack with
               | [] -> false
               | top :: tail ->
                   if matching top c then check tail rest
                   else false)
          | _ -> false
  in
  check [] char_list
