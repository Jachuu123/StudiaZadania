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
  | Pair  of expr * expr   (* konstruktor pary, zapis (e1, e2) *)
  | Fst   of expr          (* eliminator pierwszego elementu: fst p *)
  | Snd   of expr          (* eliminator drugiego elementu: snd p *)
