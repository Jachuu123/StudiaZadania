type 'a tree = 
  | Leaf 
  | Node of 'a tree * 'a * 'a tree;;

(* Wersja insert_bst umożliwiająca duplikaty.
   Jeśli x < v, to wstawiamy do lewego poddrzewa,
   w przeciwnym przypadku (x ≥ v) wstawiamy do prawego poddrzewa. *)
let rec insert_bst x t =
  match t with
  | Leaf -> Node (Leaf, x, Leaf)
  | Node (l, v, r) ->
      if x < v then Node (insert_bst x l, v, r)
      else Node (l, v, insert_bst x r);;

(* flat_append t xs – zwraca listę elementów drzewa t w kolejności infiksowej,
   dołączoną do listy xs *)
let rec flat_append t xs =
  match t with
  | Leaf -> xs
  | Node (l, v, r) -> flat_append l (v :: flat_append r xs);;

(* flatten t – zwraca listę elementów drzewa t w kolejności infiksowej *)
let flatten t = flat_append t [];;

(* tree_sort xs – buduje drzewo BST z elementów xs, a następnie zwraca posortowaną listę *)
let tree_sort xs =
  let rec build_tree xs t =
    match xs with
    | [] -> t
    | x :: xs' -> build_tree xs' (insert_bst x t)
  in
  flatten (build_tree xs Leaf);;
