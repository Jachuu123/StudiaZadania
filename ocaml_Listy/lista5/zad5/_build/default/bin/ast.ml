type expr =
  | Num of float        (* stała liczbowa typu float *)
  | Var of string       (* zmienna, jeśli obsługujemy zmienne *)
  | Add of expr * expr  (* e1 + e2 *)
  | Sub of expr * expr  (* e1 - e2 *)
  | Mul of expr * expr  (* e1 * e2 *)
  | Div of expr * expr  (* e1 / e2 *)
