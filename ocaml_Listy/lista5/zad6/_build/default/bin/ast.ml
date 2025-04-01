type expr =
  | Num of float        (* stała liczbowa typu float *)
  | Add of expr * expr  (* e1 + e2 *)
  | Sub of expr * expr  (* e1 - e2 *)
  | Mul of expr * expr  (* e1 * e2 *)
  | Div of expr * expr  (* e1 / e2 *)
  | Pow of expr * expr  (* e1 ** e2 *)
  | Log of expr         (* log e *)
