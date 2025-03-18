let rec fold_tree f a t =
  match t with
  | Leaf -> a
  | Node (l, v, r) -> f (fold_tree f a l) v (fold_tree f a r);;

let tree_product t = fold_tree (fun l v r -> l * v * r) 1 t;;

let tree_flip t = fold_tree (fun l v r -> Node(r,v,l)) Leaf t;;

let tree_height t = fold_tree(fun l _ r -> 1 + max l r) 0 t;;

let tree_span t =
  let combine (min_l, max_l) v (min_r, max_r) =
    (min v (min min_l min_r), max v (max max_l max_r))
  in
  fold_tree combine (max_int, min_int) t;;

let flatten t =
  let combine l v r = l @ [v] @ r in
  fold_tree combine [] t;;