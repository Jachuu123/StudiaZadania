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

module MakeMapDict (Ord : Map.OrderedType) : KDICT with type key = Ord.t = struct
  module M = Map.Make(Ord)
  type key = Ord.t
  type 'a dict = 'a M.t
  let empty = M.empty
  let insert k v d = M.add k v d
  let remove k d = M.remove k d
  let find_opt k d = try Some (M.find k d) with Not_found -> None
  let find k d = M.find k d
  let to_list d = M.bindings d
end

module CharOrdered : Map.OrderedType = struct
  type t = char
  let compare = Char.compare
end

module CharMapDict = MakeMapDict(CharOrdered)
