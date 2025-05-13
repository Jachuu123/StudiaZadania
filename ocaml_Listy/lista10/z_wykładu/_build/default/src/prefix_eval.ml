open Ast
open Interp

type frame =
  | Val of value
  | Op2 of bop
  | Op1 of bop * value

let rec reduce = function
  | Val v2 :: Op1 (op,v1) :: st ->
      reduce (Val (eval_op op v1 v2) :: st)
  | st -> st

let shift = function
  | Val v :: Op2 op :: st -> Op1 (op,v) :: st
  | st -> st

let push_val v st = reduce (Val v :: st)
let push_op op st = Op2 op :: st

let rec run st = function
  | [] ->
      (match st with
       | [Val v] -> v
       | _ -> failwith "malformed prefix expression")
  | tok :: toks ->
      let st' =
        match tok with
        | "+"  -> push_op Add  st
        | "-"  -> push_op Sub  st
        | "*"  -> push_op Mult st
        | "/"  -> push_op Div  st
        | "&&" -> push_op And  st
        | "||" -> push_op Or   st
        | "<=" -> push_op Leq  st
        | "<"  -> push_op Lt   st
        | ">=" -> push_op Geq  st
        | ">"  -> push_op Gt   st
        | "="  -> push_op Eq   st
        | "<>" -> push_op Neq  st
        | "true"  -> push_val (VBool true)  st
        | "false" -> push_val (VBool false) st
        | "()"    -> push_val VUnit         st
        | n       -> push_val (VInt (int_of_string n)) st
      in
      run (shift st') toks

let eval tokens = run [] tokens

let eval_string s =
  s |> String.split_on_char ' '
    |> List.filter (fun t -> String.length t > 0)
    |> eval
