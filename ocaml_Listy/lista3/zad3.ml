let rec build_list n f =
  match n with
  | 0 -> []
  | _ -> build_list (n - 1) f @ [f (n - 1)];;

let negatives n = build_list n (fun x -> -x - 1);;

let reciprocals n = build_list n (fun x -> 1. /. (float_of_int (x+1)))

let evens n = build_list n (fun x -> 2 * x)

let identityM n = build_list n (fun x -> Array.init n (fun j -> if j = x then 1 else 0))