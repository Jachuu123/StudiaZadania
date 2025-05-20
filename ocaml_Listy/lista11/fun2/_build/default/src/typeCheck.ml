open RawAst

exception Type_error  of (Lexing.position * Lexing.position) * string

exception Type_errors of ((Lexing.position * Lexing.position) * string) list

let collected_errors : ((Lexing.position * Lexing.position) * string) list ref =
  ref []

let add_error pos msg =
  collected_errors := (pos, msg) :: !collected_errors

(** Simple environment for term variables → types *)
module Env = struct
  module StrMap = Map.Make (String)
  type t = typ StrMap.t

  let empty     = StrMap.empty
  let add       = StrMap.add
  let find_opt  = StrMap.find_opt
end

(* ───────────────────────────── Pretty‑printing of types ───────────────────────────── *)
let rec string_of_typ = function
  | TUnit          -> "unit"
  | TInt           -> "int"
  | TBool          -> "bool"
  | TPair (t1,t2)  -> "(" ^ string_of_typ t1 ^ " * " ^ string_of_typ t2 ^ ")"
  | TArrow (t1,t2) ->
      let lhs = match t1 with TArrow _ -> "(" ^ string_of_typ t1 ^ ")" | _ -> string_of_typ t1 in
      lhs ^ " -> " ^ string_of_typ t2

(* ───────────────────────────── Helper for fatal errors ───────────────────────────── *)
let raise_error pos fmt =
  Printf.kprintf (fun msg -> raise (Type_error (pos, msg))) fmt

(* ───────────────────────────── Inference & checking ───────────────────────────── *)
let rec infer_type (env : Env.t) (expr : expr) : typ =
  match expr.data with
  | Unit   -> TUnit
  | Int  _ -> TInt
  | Bool _ -> TBool
  | Var x  ->
      begin match Env.find_opt x env with
      | Some tp -> tp
      | None    -> raise_error expr.pos "Unbound variable %s" x
      end

  (* binary operators *)
  | Binop ((Add|Sub|Mult|Div), e1, e2) ->
      check_type env e1 TInt; check_type env e2 TInt; TInt
  | Binop ((And|Or), e1, e2) ->
      check_type env e1 TBool; check_type env e2 TBool; TBool
  | Binop ((Leq|Lt|Geq|Gt), e1, e2) ->
      check_type env e1 TInt; check_type env e2 TInt; TBool
  | Binop ((Eq|Neq), e1, e2) ->
      let tp = infer_type env e1 in  (* tu nie ma sensu łapać błędu – wezwie check_type *)
      check_type env e2 tp; TBool

  (* conditional *)
  | If (b, e_then, e_else) ->
      check_type env b TBool;
      let tp_then = infer_type env e_then in
      check_type env e_else tp_then;
      tp_then

  (* let‑binding *)
  | Let (x, e1, e2) ->
      let tp1 = infer_type env e1 in
      infer_type (Env.add x tp1 env) e2

  (* pairs & projections *)
  | Pair (e1, e2) -> TPair (infer_type env e1, infer_type env e2)
  | Fst e ->
      (match infer_type env e with
       | TPair (tp1, _) -> tp1
       | tp -> raise_error e.pos "fst expects a pair, got %s" (string_of_typ tp))
  | Snd e ->
      (match infer_type env e with
       | TPair (_, tp2) -> tp2
       | tp -> raise_error e.pos "snd expects a pair, got %s" (string_of_typ tp))

  (* application *)
  | App (e_fun, e_arg) ->
      let tp_fun = infer_type env e_fun in
      (match tp_fun with
       | TArrow (tp_param, tp_res) ->
           check_type env e_arg tp_param; tp_res
       | _ -> raise_error e_fun.pos
                "Attempted to apply value of type %s (not a function)" (string_of_typ tp_fun))

  (* abstractions *)
  | Fun (x, tp_x, body) ->
      let tp_body = infer_type (Env.add x tp_x env) body in
      TArrow (tp_x, tp_body)
  | Funrec (f, x, tp_x, tp_res, body) ->
      let env' = env |> Env.add x tp_x |> Env.add f (TArrow (tp_x, tp_res)) in
      check_type env' body tp_res;
      TArrow (tp_x, tp_res)

and check_type (env : Env.t) (expr : expr) (expected : typ) : unit =
  let actual = infer_type env expr in
  if actual <> expected then
    add_error expr.pos
      (Printf.sprintf "Type mismatch: expected %s, got %s"
         (string_of_typ expected) (string_of_typ actual))

(* ───────────────────────────── Entry‑point ───────────────────────────── *)
let check_program (e : expr) : expr =
  collected_errors := [];
  (try ignore (infer_type Env.empty e) with
   | Type_error _ as ex -> (* fatal błąd wciąż zatrzymuje proces *) raise ex);
  match List.rev !collected_errors with
  | []      -> e                      (* brak niekrytycznych błędów *)
  | err_lst -> raise (Type_errors err_lst)
