(* interp.ml – minimal patch of original skeleton for Lab #2 / Prac‑2 *)

open Ast

(* ------------------------------------------------------------------- *)
(*  Parsing helper (unchanged)                                          *)
(* ------------------------------------------------------------------- *)
let parse (s : string) : expr =
  Parser.main Lexer.read (Lexing.from_string s)

(* ------------------------------------------------------------------- *)
(*  Environment & value – **exactly** the same as in the template       *)
(* ------------------------------------------------------------------- *)
module M = Map.Make (String)

type env = value M.t

and value =
  | VInt of int
  | VBool of bool
  | VUnit
  | VPair of value * value
  | VClosure of ident * expr * env
  | VRecClosure of ident * ident * expr * env

(* ------------------------------------------------------------------- *)
(*  Pretty‑printer                                                     *)
(* ------------------------------------------------------------------- *)
let rec show_value = function
  | VInt n -> string_of_int n
  | VBool b -> string_of_bool b
  | VUnit -> "()"
  | VPair (v1, v2) -> "(" ^ show_value v1 ^ ", " ^ show_value v2 ^ ")"
  | VClosure _ | VRecClosure _ -> "<fun>"

(* ------------------------------------------------------------------- *)
(*  Mutable hook for spreadsheet cell lookup                           *)
(* ------------------------------------------------------------------- *)
let current_cell_lookup : (int -> int -> value) ref =
  ref (fun _ _ -> failwith "Cell reference outside of spreadsheet evaluation")

(* ------------------------------------------------------------------- *)
(*  Primitive operators                                                 *)
(* ------------------------------------------------------------------- *)
let eval_op (op : bop) (val1 : value) (val2 : value) : value =
  match op, val1, val2 with
  | Add,  VInt  v1, VInt  v2 -> VInt  (v1 + v2)
  | Sub,  VInt  v1, VInt  v2 -> VInt  (v1 - v2)
  | Mult, VInt  v1, VInt  v2 -> VInt  (v1 * v2)
  | Div,  VInt  v1, VInt  v2 -> VInt  (v1 / v2)
  | And,  VBool v1, VBool v2 -> VBool (v1 && v2)
  | Or,   VBool v1, VBool v2 -> VBool (v1 || v2)
  | Leq,  VInt  v1, VInt  v2 -> VBool (v1 <= v2)
  | Lt,   VInt  v1, VInt  v2 -> VBool (v1 < v2)
  | Gt,   VInt  v1, VInt  v2 -> VBool (v1 > v2)
  | Geq,  VInt  v1, VInt  v2 -> VBool (v1 >= v2)
  | Neq,  _,         _       -> VBool (val1 <> val2)
  | Eq,   _,         _       -> VBool (val1 = val2)
  | _,    _,         _       -> failwith "type error"

(* ------------------------------------------------------------------- *)
(*  Core interpreter – **only two new cases added (Match, Cell)**       *)
(* ------------------------------------------------------------------- *)
let rec eval_env (env : env) (e : expr) : value =
  match e with
  | Int i -> VInt i
  | Bool b -> VBool b
  | Binop (op, e1, e2) -> eval_op op (eval_env env e1) (eval_env env e2)
  | If (b, t, f) ->
      (match eval_env env b with
       | VBool true  -> eval_env env t
       | VBool false -> eval_env env f
       | _ -> failwith "type error")
  | Var x ->
      (match M.find_opt x env with
       | Some v -> v
       | None -> failwith "unknown var")
  | Let (x, e1, e2) -> eval_env (M.add x (eval_env env e1) env) e2
  | Pair (e1, e2) -> VPair (eval_env env e1, eval_env env e2)
  | Unit -> VUnit
  | Fst e ->
      (match eval_env env e with
       | VPair (v1, _) -> v1
       | _ -> failwith "type error")
  | Snd e ->
      (match eval_env env e with
       | VPair (_, v2) -> v2
       | _ -> failwith "type error")
  | Match (e1, x, y, e2) ->
      (match eval_env env e1 with
       | VPair (v1, v2) ->
           let env' = env |> M.add x v1 |> M.add y v2 in
           eval_env env' e2
       | _ -> failwith "type error")
  | IsPair e ->
      (match eval_env env e with
       | VPair _ -> VBool true
       | _ -> VBool false)
  | Fun (x, body) -> VClosure (x, body, env)
  | Funrec (f, x, body) -> VRecClosure (f, x, body, env)
  | App (e1, e2) ->
      let v1 = eval_env env e1 in
      let v2 = eval_env env e2 in
      (match v1 with
       | VClosure (x, body, clo_env) -> eval_env (M.add x v2 clo_env) body
       | VRecClosure (f, x, body, clo_env) as c ->
           eval_env (clo_env |> M.add x v2 |> M.add f c) body
       | _ -> failwith "not a function")
  | Cell (row, col) -> (!current_cell_lookup) row col

(* ------------------------------------------------------------------- *)
(*  Spreadsheet evaluation                                              *)
(* ------------------------------------------------------------------- *)
type cell_state = NotVisited | Visiting | Done of value
exception Cycle

let eval_spreadsheet (sheet : expr list list) : value list list option =
  match sheet with
  | [] -> Some []
  | first_row :: _ ->
      let rows = List.length sheet in
      let cols = List.length first_row in
      if List.exists (fun r -> List.length r <> cols) sheet then
        failwith "Ragged spreadsheet (rows of unequal length)";
      let expr_tbl = Array.of_list (List.map Array.of_list sheet) in
      let state_tbl = Array.init rows (fun _ -> Array.make cols NotVisited) in
      let val_tbl   = Array.init rows (fun _ -> Array.make cols VUnit) in

      (* DFS with memoisation & cycle detection *)
      let eval_cell r c : value =
        if r < 0 || r >= rows || c < 0 || c >= cols then
          failwith "Cell index out of bounds";
        match state_tbl.(r).(c) with
        | Done v -> v
        | Visiting -> raise Cycle
        | NotVisited ->
            state_tbl.(r).(c) <- Visiting;
            let v = eval_env M.empty expr_tbl.(r).(c) in
            state_tbl.(r).(c) <- Done v;
            val_tbl.(r).(c) <- v;
            v
      in

      let old_lookup = !current_cell_lookup in
      current_cell_lookup := eval_cell;
      let res =
        try
          for r = 0 to rows - 1 do
            for c = 0 to cols - 1 do
              ignore (eval_cell r c)
            done
          done;
          let out =
            Array.to_list (Array.map (fun row -> Array.to_list row) val_tbl)
          in
          Some out
        with Cycle -> None
      in
      current_cell_lookup := old_lookup; (* restore regardless of outcome *)
      res

(* ------------------------------------------------------------------- *)
(*  Convenience function used by the harness                            *)
(* ------------------------------------------------------------------- *)
let parse_and_eval_spreadsheet (s : string list list) : string list list option =
  let es = List.map (List.map parse) s in
  let vs = eval_spreadsheet es in
  Option.map (List.map (List.map show_value)) vs
