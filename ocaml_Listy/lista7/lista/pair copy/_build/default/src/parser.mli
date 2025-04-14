
(* The type of tokens. *)

type token = 
  | WITH
  | UNIT
  | TIMES
  | THEN
  | SND
  | SEMI
  | RSPAREN
  | RPAREN
  | RBRACKET
  | PLUS
  | OR
  | MINUS
  | MATCH
  | LSPAREN
  | LPAREN
  | LET
  | LEQ
  | LBRACKET
  | IS_UNIT
  | IS_PAIR
  | IS_NUMBER
  | IS_BOOL
  | INT of (int)
  | IN
  | IF
  | IDENT of (string)
  | FST
  | FOLD_AND
  | FOLD
  | EQ
  | EOF
  | ELSE
  | DIV
  | COMMA
  | BOOL of (bool)
  | ARR
  | AND

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val main: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.expr)
