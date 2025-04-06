type bop =
  (* arithmetic *)
  | Add | Sub | Mult | Div
  (* logic *)
  | And | Or
  (* comparison *)
  | Eq | Leq

type ident = string

type expr = 
  | Int   of int
  | Binop of bop * expr * expr
  | Bool  of bool
  | If    of expr * expr * expr
  | Let   of ident * expr * expr
  | Var   of ident

let rec closed_aux env e =
  match e with
  | Var x -> List.mem x env
  | Int _ | Bool _ -> true
  | Binop (_, e1, e2) -> closed_aux env e1 && closed_aux env e2
  | If (e1, e2, e3) -> closed_aux env e1 && closed_aux env e2 && closed_aux env e3
  | Let (x, e1, e2) -> closed_aux env e1 && closed_aux (x :: env) e2

let closed e = closed_aux [] e
