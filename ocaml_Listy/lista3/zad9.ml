(* Reprezentacja drzewa BST *)
type 'a tree = 
  | Leaf 
  | Node of 'a tree * 'a * 'a tree

(* Funkcja delete: usuwa klucz x z drzewa t *)
let rec delete x t =
  match t with
  | Leaf -> Leaf  (* Klucz nie został znaleziony *)
  | Node (l, v, r) ->
      if x < v then
        Node (delete x l, v, r)   (* Przechodzimy do lewego poddrzewa *)
      else if x > v then
        Node (l, v, delete x r)   (* Przechodzimy do prawego poddrzewa *)
      else
        (* Znaleziono węzeł z kluczem x, czyli v = x *)
        match (l, r) with
        | (Leaf, _) -> r        (* Jeśli brak lewego poddrzewa, zwracamy prawe *)
        | (_, Leaf) -> l        (* Jeśli brak prawego poddrzewa, zwracamy lewe *)
        | (_, _) ->
            (* Oba poddrzewia istnieją.
               Znajdujemy najmniejszy element w prawym poddrzewie (następnik in-order) *)
            let rec find_min t =
              match t with
              | Node (Leaf, v, _) -> v
              | Node (l, _, _) -> find_min l
              | Leaf -> failwith "Błąd: find_min wywołany na Leaf"
            in
            let successor = find_min r in
            (* Zastępujemy wartość węzła successor i usuwamy go z prawego poddrzewa *)
            Node (l, successor, delete successor r)
