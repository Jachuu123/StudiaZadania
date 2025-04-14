type 'a tree = Leaf | Node of 'a tree * 'a * 'a tree
type 'a sgtree = { tree : 'a tree ; size : int ; max_size : int }

let alpha_height n =
  let inv_alpha = 4.0 /. 3.0 in
  let h = floor (log (float_of_int n) /. log inv_alpha) in
  int_of_float h

let rec inorder (t : 'a tree) : 'a list =
  match t with
  | Leaf -> []
  | Node (l, x, r) -> inorder l @ (x :: inorder r)


let rec build_balanced xs =
  match xs with
  | [] -> Leaf
  | _ ->
      let len = List.length xs in
      let take = len / 2 in
      let left_list = take take xs in
      let x = List.nth xs take in
      let right_list = drop (take+1) xs in
      Node (build_balanced left_list, x, build_balanced right_list)

let rebuild_balanced (t : 'a tree) : 'a tree =
  let elems = inorder t in
  build_balanced elems

let empty = {
  tree = Leaf;
  size = 0;
  max_size = 0;
}

let rec bst_find x = function
  | Leaf -> false
  | Node (l, y, r) ->
      if x = y then true
      else if x < y then bst_find x l
      else bst_find x r

let find x sgt =
  bst_find x sgt.tree

let rec take n xs =
  match xs, n with
  | _, 0 -> []
  | [], _ -> []
  | x :: t, _ -> x :: take (n - 1) t

let rec drop n xs =
  match xs, n with
  | [], _ -> []
  | l, 0 -> l
  | _ :: t, n -> drop (n - 1) t

  
