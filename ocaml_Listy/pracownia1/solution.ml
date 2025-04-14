let alpha_num = 3
let alpha_denom = 4
let alpha = float_of_int alpha_num /. float_of_int alpha_denom

type 'a tree =
  | Leaf
  | Node of 'a tree * 'a * 'a tree

type 'a sgtree = {
  tree : 'a tree;
  size : int;
  max_size : int;
}

let alpha_height n =
    if n <= 1 then 0
    else int_of_float (floor (log (float_of_int n) /. (-. log alpha)))
  

let rec size_of_tree = function
  | Leaf -> 0
  | Node (l, _, r) -> 1 + size_of_tree l + size_of_tree r

let rec inorder = function
  | Leaf -> []
  | Node (l, x, r) -> inorder l @ (x :: inorder r)

let empty = { tree = Leaf; size = 0; max_size = 0 }

let rec bst_find x = function
  | Leaf -> false
  | Node (l, y, r) ->
      if x = y then true
      else if x < y then bst_find x l
      else bst_find x r

let find x sgt =
  bst_find x sgt.tree

let rec bst_insert x depth = function
  | Leaf -> Node (Leaf, x, Leaf), depth
  | Node (l, y, r) ->
      if x < y then
        let l', d' = bst_insert x (depth + 1) l in
        Node (l', y, r), d'
      else if x > y then
        let r', d' = bst_insert x (depth + 1) r in
        Node (l, y, r'), d'
      else failwith "insert: element already in the tree"

let rec find_path t x =
  match t with
  | Leaf -> [Leaf]
  | Node (l, y, r) ->
      if x = y then [t]
      else if x < y then t :: find_path l x
      else t :: find_path r x

let is_scapegoat t =
  match t with
  | Leaf -> false
  | Node (l, _, _) ->
      let total = size_of_tree t in
      let ln = size_of_tree l in
      let rn = total - ln - 1 in
      let nf = float_of_int total in
      let lf = float_of_int ln in
      let rf = float_of_int rn in
      lf > alpha *. nf || rf > alpha *. nf

let rec replace_subtree current scapegoat_subtree rebuilt_subtree =
  if current == scapegoat_subtree then rebuilt_subtree
  else
    match current with
    | Leaf -> Leaf
    | Node (l, y, r) ->
        Node (
          replace_subtree l scapegoat_subtree rebuilt_subtree,
          y,
          replace_subtree r scapegoat_subtree rebuilt_subtree
        )

let rec build_balanced_array arr start len =
  if len <= 0 then Leaf
  else
    let mid = start + (len / 2) in
    let left_len = mid - start in
    let right_len = len - left_len - 1 in
    let left_tree = build_balanced_array arr start left_len in
    let x = arr.(mid) in
    let right_tree = build_balanced_array arr (mid + 1) right_len in
    Node (left_tree, x, right_tree)

let rebuild_balanced t =
  let elems = inorder t in
  let arr = Array.of_list elems in
  build_balanced_array arr 0 (Array.length arr)

let build_new_root path scapegoat_subtree =
  let rebuilt_subtree = rebuild_balanced scapegoat_subtree in
  let root = List.hd path in
  replace_subtree root scapegoat_subtree rebuilt_subtree

let insert x sgt =
  let new_tree, inserted_depth = bst_insert x 0 sgt.tree in
  let new_size = sgt.size + 1 in
  let new_max_size = if new_size > sgt.max_size then new_size else sgt.max_size in
  let sgt_temp = { tree = new_tree; size = new_size; max_size = new_max_size } in
  let max_allowed_height = alpha_height new_size + 1 in
  if inserted_depth <= max_allowed_height then sgt_temp
  else
    let path = find_path new_tree x in
    let rec find_scapegoat_in_path = function
      | [] -> None
      | t :: rest -> if is_scapegoat t then Some t else find_scapegoat_in_path rest
    in
    match find_scapegoat_in_path (List.rev path) with
    | None -> sgt_temp
    | Some scapegoat_subtree ->
        let new_root = build_new_root path scapegoat_subtree in
        { tree = new_root; size = new_size; max_size = new_max_size }

let rec bst_min = function
  | Leaf -> failwith "bst_min: empty"
  | Node (Leaf, m, _) -> m
  | Node (l, _, _) -> bst_min l

let rec bst_remove x = function
  | Leaf -> failwith "remove: element not found"
  | Node (l, y, r) ->
      if x < y then Node (bst_remove x l, y, r)
      else if x > y then Node (l, y, bst_remove x r)
      else
        match l, r with
        | Leaf, Leaf -> Leaf
        | Leaf, _ -> r
        | _, Leaf -> l
        | _ ->
            let m = bst_min r in
            Node (l, m, bst_remove m r)

let remove x sgt =
  let new_tree = bst_remove x sgt.tree in
  let new_size = sgt.size - 1 in
  let sgt_temp = { tree = new_tree; size = new_size; max_size = sgt.max_size } in
  if float_of_int new_size >= alpha *. float_of_int sgt.max_size then sgt_temp
  else
    let rebuilt = rebuild_balanced new_tree in
    { tree = rebuilt; size = new_size; max_size = new_size }

