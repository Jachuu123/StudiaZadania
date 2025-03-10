let rec mem x xs =
  match xs with
  | [] -> false
  | y :: ys -> (x = y) || mem x ys;;
