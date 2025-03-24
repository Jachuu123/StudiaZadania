module type DICT = sig
    type ('a, 'b) dict
    val empty : ('a, 'b) dict
    val insert : 'a -> 'b -> ('a, 'b) dict -> ('a, 'b) dict
    val remove : 'a -> ('a, 'b) dict -> ('a, 'b) dict
    val find_opt : 'a -> ('a, 'b) dict -> 'b option
    val find : 'a -> ('a, 'b) dict -> 'b
    val to_list : ('a, 'b) dict -> ('a * 'b) list
  end
  
  module ListDict : DICT = struct
    type ('a, 'b) dict = ('a * 'b) list
    let empty = []
    let insert k v d = (k, v) :: List.remove_assoc k d
    let remove k d = List.remove_assoc k d
    let find_opt k d =
      try Some (List.assoc k d) with Not_found -> None
    let find k d = List.assoc k d
    let to_list d = d
  end
  
  (*
  let rec assoc key = function
  | [] -> raise Not_found
  | (k, v) :: rest -> if k = key then v else assoc key rest

  let rec assoc key = function
  | [] -> raise Not_found
  | (k, v) :: rest -> if k = key then v else assoc key rest
  *)