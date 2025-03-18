let fold_left f a xs =
  let rec it xs acc =
    match xs with
    | [] -> acc
    | x::xs -> it xs (f acc x)
  in it xs a;;

  let rec fold_right f xs a =
  match xs with
  | [] -> a
  | x::xs -> f x (fold_right f xs a);;