open Ast
open Lexing

let parse (s : string) : expr =
  Parser.main Lexer.token (from_string s)

let rec eval expr =
  match expr with
  | Const n      -> n
  | Plus (e1, e2)  -> eval e1 +. eval e2
  | Minus (e1, e2) -> eval e1 -. eval e2
  | Times (e1, e2) -> eval e1 *. eval e2
  | Div (e1, e2)   -> eval e1 /. eval e2

let interp (s : string) : float =
  eval (parse s)
