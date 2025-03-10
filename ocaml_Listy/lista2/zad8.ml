let rec select xs =
  match xs with
  | [] ->
    failwith "select: nie można wybrać z pustej listy"
  | [x] ->
    (x, [])
  | x :: xs' ->
    let (m, ys) = select xs' in
    if x <= m
    then (x, m :: ys)  (* x jest mniejsze, a poprzednie minimum dajemy z powrotem do listy *)
    else (m, x :: ys);;

let rec select_sort xs =
  match xs with
  | [] -> []
  | _ ->
    let (m, ys) = select xs in
    m :: select_sort ys;;
