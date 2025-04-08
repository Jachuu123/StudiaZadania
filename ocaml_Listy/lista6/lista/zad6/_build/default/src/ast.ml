type bop =
  (* arithmetic *)
  | Add | Sub | Mult | Div
  (* logic *)
  | And | Or
  (* comparison *)
  | Eq | Leq

type ident = string

type expr =
  | Int of int
  | Binop of bop * expr * expr
  | Bool of bool
  | If of expr * expr * expr
  | Let of ident * expr * expr
  | Var of ident
  | Unit
  | Pair of expr * expr
  | Fst of expr
  | Snd of expr
  | MatchPair of expr * ident * ident * expr
  | Sum of ident * expr * expr * expr  (* Nowa konstrukcja: sum x = n to m in k *)



