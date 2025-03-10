let rec split xs =
  match xs with
  | [] -> ([], [])
  | [x] -> ([x], [])
  | x :: y :: rest ->
    let (xs1, xs2) = split rest in
    (x :: xs1, y :: xs2);;

let rec merge xs ys =
  match (xs, ys) with
  | ([], _) -> ys
  | (_, []) -> xs
  | (x :: xs', y :: ys') ->
    if x <= y
    then x :: merge xs' ys
    else y :: merge xs ys';;

let rec merge_sort xs =
  match xs with
  | [] -> []
  | [_] -> xs
  | _ ->
    let (left, right) = split xs in
    merge (merge_sort left) (merge_sort right);;
