
(* The type of tokens. *)

type token = 
  | TIMES
  | RPAREN
  | PLUS
  | MINUS
  | LPAREN
  | INT of (int)
  | EOF
  | DIV

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val main: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.expr)
