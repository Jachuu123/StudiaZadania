let alpha_num = 3
let alpha_denom = 4

type 'a tree = Leaf | Node of 'a tree * 'a * 'a tree
type 'a sgtree = { tree : 'a tree; size : int; max_size: int }

let alpha_height (n : int) : int =
  int_of_float (Float.floor ((Float.log (float_of_int n)) /. (Float.log (float_of_int alpha_denom /. float_of_int alpha_num))))

let flatten_fast (t: 'a tree): 'a list =
  let rec it t acc = match t with
    | Leaf -> acc
    | Node (l,v,r) -> it l (v :: (it r acc))
  in it t []

let rec insert_bst (x: 'a) = function
  | Leaf -> Node (Leaf, x, Leaf)
  | Node(left, v, right) ->
      if x = v then Node(left,v,right)
      else if x > v then Node(left, v, insert_bst x right)
      else Node(insert_bst x left, v, right)

let list_split (xs: 'a list): 'a list * 'a list =
  let rec it i xs acc counter =
    match xs with
    | [] -> acc
    | x::tail ->
        if i > counter then it i tail ((x :: fst acc), tail) (counter+1)
        else (List.rev (fst acc), snd acc)
  in it (List.length xs / 2) xs ([],[]) 0

let list_to_tree (xs: 'a list): 'a tree =
  let rec it xs acc = match xs with
    | [] -> acc
    | _ -> match list_split xs with
           | left, e::right -> it right (it left (insert_bst e acc))
           | left, [] -> it left (insert_bst (List.hd xs) acc)
  in it xs Leaf

let rebuild_balanced (t : 'a tree) : 'a tree =
  list_to_tree (flatten_fast t)

let empty : 'a sgtree = { tree = Leaf; size = 0; max_size = alpha_height 0 }

let rec find (x : 'a) (sgt : 'a sgtree) : bool =
  match sgt.tree with
  | Leaf -> false
  | Node (left, v, right) ->
      if v = x then true
      else if x > v then find x { tree = right; size = sgt.size; max_size = sgt.max_size }
      else find x { tree = left; size = sgt.size; max_size = sgt.max_size }

let rec size : ('a tree -> int) = function
  | Leaf -> 0
  | Node(left, v, right) -> 1 + size left + size right

let find_path (x : 'a) (tree : 'a tree) : ('a tree list) =
  let rec it x tree path =
    match tree with
    | Leaf -> failwith "Element not found!"
    | Node (left, v, right) ->
        if v = x then path
        else if x > v then it x right (right :: path)
        else it x left (left :: path)
  in it x tree [tree]

let left_el (tree: 'a tree): 'a tree =
  match tree with
  | Node (l, _, _) -> l
  | Leaf -> Leaf

let right_el (tree: 'a tree): 'a tree =
  match tree with
  | Node (_, _, r) -> r
  | Leaf -> Leaf

let is_ok_tree (t: 'a tree): bool =
  float_of_int (size (left_el t)) <= (float_of_int alpha_num /. float_of_int alpha_denom) *. float_of_int (size t) &&
  float_of_int (size (right_el t)) <= (float_of_int alpha_num /. float_of_int alpha_denom) *. float_of_int (size t)

let rec replace (x: 'a) (p_tree: 'a tree) (tree: 'a tree) =
  match p_tree with
  | Leaf -> tree
  | Node(left, v, right) ->
      if x > v then Node(left, v, replace x right tree)
      else if x < v then Node(replace x left tree, v, right)
      else tree

let rec repair (path: 'a tree list) =
  match path with
  | [] -> failwith "Unexpected behaviour"
  | t :: tail ->
      if is_ok_tree t then repair tail
      else
        match tail with
        | [] -> t
        | _ ->
            (match t with
             | Leaf -> failwith "Unexpected behaviour"
             | Node(_, v, _) -> replace v (List.nth (List.rev tail) 0) (rebuild_balanced t))

let rec depth : ('a tree -> int) = function
  | Leaf -> 0
  | Node(left, _, right) -> 1 + max (depth left) (depth right)

let insert (x : 'a) (sgt : 'a sgtree): 'a sgtree =
  let rec it curr_height x t =
    match t with
    | Leaf -> (Node (Leaf, x, Leaf), curr_height)
    | Node(left, v, right) ->
        if x = v then failwith "Repeating values"
        else if x > v then
          let (tr, height) = it (curr_height + 1) x right in
          (Node(left, v, tr), height)
        else
          let (tr, height) = it (curr_height + 1) x left in
          (Node(tr, v, right), height)
  in
  let (new_tree, depth_x) = it 0 x sgt.tree in
  let fixed_tree =
    if depth_x > alpha_height (sgt.size + 1) then repair (find_path x new_tree)
    else new_tree
  in
  if depth fixed_tree > alpha_height (sgt.size + 1) + 1 then failwith "Height exceeds alpha_height"
  else { tree = fixed_tree; size = sgt.size + 1; max_size = (if sgt.size + 1 > sgt.max_size then sgt.size + 1 else sgt.max_size) }

let remove_bst_helper (tree: 'a tree) : ('a tree * 'a) =
  let rec it tree =
    match tree with
    | Leaf -> failwith "Unexpected behaviour"
    | Node (Leaf, v', rnode) -> (rnode, v')
    | Node(lnode, v', rnode) ->
        let (lnode', min) = it lnode in
        (Node (lnode', v', rnode), min)
  in it tree

let rec remove_bst (tree: 'a tree) (x: 'a) : 'a tree =
  match tree with
  | Leaf -> failwith "Element not found"
  | Node(left, v, right) ->
      if x > v then Node(left, v, remove_bst right x)
      else if x < v then Node(remove_bst left x, v, right)
      else
        (match Node(left, v, right) with
         | Node(Leaf, v, Leaf) -> Leaf
         | Node(lnode, v, Leaf) -> lnode
         | Node(Leaf, v, rnode) -> rnode
         | Node(lnode, v, rnode) ->
             let (rnode', a) = remove_bst_helper rnode in
             Node(lnode, a, rnode')
         | Leaf -> failwith "Unexpected behaviour")

let remove (x : 'a) (sgt : 'a sgtree) : 'a sgtree =
  let s = sgt.size in
  let max_size = sgt.max_size in
  let t = sgt.tree in
  let tree_removed = remove_bst t x in
  if float_of_int s -. 1. < float_of_int max_size *. float_of_int alpha_num /. float_of_int alpha_denom
  then { tree = rebuild_balanced tree_removed; size = s - 1; max_size = size tree_removed }
  else { tree = tree_removed; size = s - 1; max_size = max_size }
