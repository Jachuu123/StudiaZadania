open Ast
open Lexing

let parse s =
  Parser.main Lexer.token (from_string s)

let rec eval expr =
  match expr with
  | Num f -> f
  | Add (e1, e2) -> eval e1 +. eval e2
  | Sub (e1, e2) -> eval e1 -. eval e2
  | Mul (e1, e2) -> eval e1 *. eval e2
  | Div (e1, e2) -> eval e1 /. eval e2
  | Var _ -> failwith "Zmienne niezaimplementowane"

let interp s =
  eval (parse s)