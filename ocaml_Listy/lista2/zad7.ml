let rec is_sorted xs =
  match xs with
  | [] -> true
  | [_] -> true
  | x :: y :: rest -> x <= y && is_sorted (y :: rest);;
