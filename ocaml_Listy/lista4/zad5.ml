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

module Freq (D : KDICT) = struct
  let freq (xs : D.key list) : (D.key * int) list =
    (* Przechodzimy po liście xs, aktualizując słownik frekwencji *)
    let dict =
      List.fold_left (fun acc x ->
        let current = match D.find_opt x acc with
          | None -> 0
          | Some count -> count
        in
        (* Usuwamy ewentualne stare wystąpienie i wstawiamy zaktualizowaną wartość *)
        let acc = D.remove x acc in
        D.insert x (current + 1) acc
      ) D.empty xs
    in
    D.to_list dict
end
