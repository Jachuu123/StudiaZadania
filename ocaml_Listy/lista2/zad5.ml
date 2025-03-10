let rec maximum xs =
  match xs with
  | [] -> neg_infinity
  | x :: xs' ->
     let m = maximum xs' in
     if x > m then x else m;;
