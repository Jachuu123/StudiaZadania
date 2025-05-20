open RawAst

exception Type_error of (Lexing.position * Lexing.position) * string

(** Simple environment for term variables → types *)
module Env = struct
  module StrMap = Map.Make (String)
  type t = typ StrMap.t

  let empty     = StrMap.empty
  let add       = StrMap.add
  let find_opt  = StrMap.find_opt
end

(* ───────────────────────────── Pretty-printing of types ───────────────────────────── *)
let rec string_of_typ = function
  | TUnit          -> "unit"
  | TInt           -> "int"
  | TBool          -> "bool"
  | TPair (t1,t2)  -> "(" ^ string_of_typ t1 ^ " * " ^ string_of_typ t2 ^ ")"
  | TArrow (t1,t2) ->
      let lhs =
        match t1 with
        | TArrow _ -> "(" ^ string_of_typ t1 ^ ")"
        | _        -> string_of_typ t1
      in
      lhs ^ " -> " ^ string_of_typ t2

let type_error (pos : Lexing.position * Lexing.position) expected got =
  raise
    (Type_error
       ( pos
       , Printf.sprintf
           "Type mismatch: expected %s, got %s"
           (string_of_typ expected)
           (string_of_typ got) ))

let rec infer_type (env : Env.t) (expr : expr) : typ =
  match expr.data with
  | Unit   -> TUnit
  | Int  _ -> TInt
  | Bool _ -> TBool
  | Var x  ->
      begin
        match Env.find_opt x env with
        | Some tp -> tp
        | None ->
            raise
              (Type_error
                 ( expr.pos
                 , Printf.sprintf "Unbound variable %s" x ))
      end

  | Binop ((Add | Sub | Mult | Div), e1, e2) ->
      check_type env e1 TInt;
      check_type env e2 TInt;
      TInt
  | Binop ((And | Or), e1, e2) ->
      check_type env e1 TBool;
      check_type env e2 TBool;
      TBool
  | Binop ((Leq | Lt | Geq | Gt), e1, e2) ->
      check_type env e1 TInt;
      check_type env e2 TInt;
      TBool
  | Binop ((Eq | Neq), e1, e2) ->
      let tp = infer_type env e1 in
      check_type env e2 tp;
      TBool

  | If (b, e_then, e_else) ->
      check_type env b TBool;
      let tp_then = infer_type env e_then in
      check_type env e_else tp_then;
      tp_then

  | Let (x, e1, e2) ->
      let tp1 = infer_type env e1 in
      infer_type (Env.add x tp1 env) e2

  | Pair (e1, e2) ->
      TPair (infer_type env e1, infer_type env e2)
  | Fst e ->
      begin
        match infer_type env e with
        | TPair (tp1, _) -> tp1
        | tp ->
            raise
              (Type_error
                 ( e.pos
                 , Printf.sprintf
                     "fst expects a pair, got %s"
                     (string_of_typ tp) ))
      end
  | Snd e ->
      begin
        match infer_type env e with
        | TPair (_, tp2) -> tp2
        | tp ->
            raise
              (Type_error
                 ( e.pos
                 , Printf.sprintf
                     "snd expects a pair, got %s"
                     (string_of_typ tp) ))
      end

  | App (e_fun, e_arg) ->
      let tp_fun = infer_type env e_fun in
      begin
        match tp_fun with
        | TArrow (tp_param, tp_res) ->
            check_type env e_arg tp_param;
            tp_res
        | _ ->
            raise
              (Type_error
                 ( e_fun.pos
                 , Printf.sprintf
                     "Attempted to apply value of type %s (not a function)"
                     (string_of_typ tp_fun) ))
      end

  | Fun (x, tp_x, body) ->
      let tp_body = infer_type (Env.add x tp_x env) body in
      TArrow (tp_x, tp_body)

  | Funrec (f, x, tp_x, tp_res, body) ->
      let env' =
        env |> Env.add x tp_x |> Env.add f (TArrow (tp_x, tp_res))
      in
      check_type env' body tp_res;
      TArrow (tp_x, tp_res)

and check_type (env : Env.t) (expr : expr) (expected : typ) : unit =
  let actual = infer_type env expr in
  if actual = expected then ()
  else type_error expr.pos expected actual

(* ───────────────────────────── Entry-point ───────────────────────────── *)
let check_program (e : expr) : expr =
  (* infer_type rzuci wyjątek Type_error, jeśli w programie jest błąd *)
  ignore (infer_type Env.empty e);
  e

(*

open Fun
open Lexing

let ok   = Parser.main Lexer.read (from_string "let id = (fun (x:int) -> x) in id 42");;
TypeCheck.check_program ok;;

let bad  = Parser.main Lexer.read (from_string "fst 10");;
TypeCheck.check_program bad;;

*)