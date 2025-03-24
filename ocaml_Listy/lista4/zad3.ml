   module type KDICT = sig
     type key
     type 'a dict
     val empty : 'a dict
     val insert : key -> 'a -> 'a dict -> 'a dict
     val remove : key -> 'a dict -> 'a dict
     val find_opt : key -> 'a dict -> 'a option
     val find : key -> 'a dict -> 'a
     val to_list : 'a dict -> (key * 'a) list
   end


module MakeListDict (Ord : Map.OrderedType) : (KDICT with type key = Ord.t) = struct

  type key = Ord.t
  type 'a dict = (key * 'a) list

  let empty = []

  let insert (k : key) (v : 'a) (d : 'a dict) : 'a dict =
    (k, v) :: d

  let remove (k : key) (d : 'a dict) : 'a dict =
    List.filter (fun (k', _) -> Ord.compare k k' <> 0) d

  let find_opt (k : key) (d : 'a dict) : 'a option =
    match List.find_opt (fun (k', _) -> Ord.compare k k' = 0) d with
    | None -> None
    | Some (_, value) -> Some value

  let find (k : key) (d : 'a dict) : 'a =
    match find_opt k d with
    | Some v -> v
    | None -> failwith "Key not found"

  let to_list (d : 'a dict) : (key * 'a) list =
    d
end
