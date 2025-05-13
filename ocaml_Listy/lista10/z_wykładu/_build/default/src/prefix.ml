open Ast

let bop_to_tok = function
  | Add  -> "+"
  | Sub  -> "-"
  | Mult -> "*"
  | Div  -> "/"
  | And  -> "&&"
  | Or   -> "||"
  | Eq   -> "="
  | Neq  -> "<>"
  | Leq  -> "<="
  | Lt   -> "<"
  | Geq  -> ">="
  | Gt   -> ">"

let rec tokens (e : expr) : string list =
  let open List in
  match e with
  | Int n            -> [string_of_int n]
  | Bool b           -> [string_of_bool b]
  | Unit             -> ["()"]
  | Var x            -> [x]
  | Binop (op,e1,e2) -> bop_to_tok op :: tokens e1 @ tokens e2
  | If (c,t,e)       -> "if"    :: tokens c @ tokens t @ tokens e
  | Let (x,e1,e2)    -> "let"   :: x :: tokens e1 @ tokens e2
  | Pair (e1,e2)     -> "pair"  :: tokens e1 @ tokens e2
  | Fst e            -> ["fst"]    @ tokens e
  | Snd e            -> ["snd"]    @ tokens e
  | IsPair e         -> ["pair?"]  @ tokens e
  | Match (e,x,y,body) -> "match" :: tokens e @ [x; y] @ tokens body
  | Fun (x,body)       -> "fun"   :: x :: tokens body
  | Funrec (f,x,body)  -> "funrec":: f :: x :: tokens body
  | App (e1,e2)        -> "@"     :: tokens e1 @ tokens e2

let to_string e = String.concat " " (tokens e)
