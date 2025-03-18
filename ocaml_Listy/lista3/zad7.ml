let rec flat_append t xs =
  match t with
  | Leaf -> xs
  | Node (l, v, r) ->
      flat_append l (v :: flat_append r xs);;

let flatten t = flat_append t [];;
