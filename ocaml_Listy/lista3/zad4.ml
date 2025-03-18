let empty_set _ = false;;
let singleton a = fun x -> x = a;;

let rec in_set a s = 
    match s with
    | [] -> false
    | x::xs -> if x = a then true else in_set a xs;;

let union s t = fun x -> s x || t x;;

let intersect s t = fun x -> s x && t x;;

let set1 = singleton 1;;
let set2 = singleton 2;;
let union_set = union set1 set2;;
let intersect_set = intersect set1 set2;;
let intersect_set1 = intersect set1 set1;;

union_set 1;;
union_set 2;;
union_set 3;;

intersect_set 1;;
intersect_set 2;;
intersect_set1 1;;