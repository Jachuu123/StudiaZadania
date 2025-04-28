open Ast

let parse (s : string) : expr =
  Parser.main Lexer.read (Lexing.from_string s)

type value =
  | VInt of int
  | VBool of bool

let eval_op (op : bop) (val1 : value) (val2 : value) : value =
  match op, val1, val2 with
  | Add,  VInt  v1, VInt  v2 -> VInt  (v1 + v2)
  | Sub,  VInt  v1, VInt  v2 -> VInt  (v1 - v2)
  | Mult, VInt  v1, VInt  v2 -> VInt  (v1 * v2)
  | Div,  VInt  v1, VInt  v2 -> VInt  (v1 / v2)
  | And,  VBool v1, VBool v2 -> VBool (v1 && v2)
  | Or,   VBool v1, VBool v2 -> VBool (v1 || v2)
  | Leq,  VInt  v1, VInt  v2 -> VBool (v1 <= v2)
  | Eq,   _,        _        -> VBool (val1 = val2)
  | _,    _,        _        -> failwith "type error"

let rec subst (x : ident) (s : expr) (e : expr) : expr =
  match e with
  | Binop (op, e1, e2) -> Binop (op, subst x s e1, subst x s e2)
  | If (b, t, e) -> If (subst x s b, subst x s t, subst x s e)
  | Var y -> if x = y then s else e
  | Let (y, e1, e2) ->
      Let (y, subst x s e1, if x = y then e2 else subst x s e2)
  | _ -> e

let reify (v : value) : expr =
  match v with
  | VInt a -> Int a
  | VBool b -> Bool b

let rec eval (e : expr) : value =
  match e with
  | Int i -> VInt i
  | Bool b -> VBool b
  | Binop (op, e1, e2) ->
      eval_op op (eval e1) (eval e2)
  | If (b, t, e) ->
      (match eval b with
           | VBool true -> eval t
           | VBool false -> eval e
           | _ -> failwith "type error")
  | Let (x, e1, e2) ->
      eval (subst x (reify (eval e1)) e2)
  | Var x -> failwith ("unknown var " ^ x)

module StringMap = Map.Make(String)  (* alpha-equivalence: fresh mapping *)

type env = expr StringMap.t  (* constant propagation environment *)

let alpha_equiv (e1 : expr) (e2 : expr) : bool =  (* alpha-equivalence main function *)
  let rec aux env1 env2 a b =
    match a, b with
    | Int n1, Int n2 -> n1 = n2
    | Bool b1, Bool b2 -> b1 = b2
    | Binop (op1,l1,r1), Binop (op2,l2,r2) ->
        op1 = op2 && aux env1 env2 l1 l2 && aux env1 env2 r1 r2
    | If (c1,t1,e1'), If (c2,t2,e2') ->
        aux env1 env2 c1 c2 && aux env1 env2 t1 t2 && aux env1 env2 e1' e2'
    | Let (x1,b1,in1), Let (x2,b2,in2) ->
        aux env1 env2 b1 b2 &&
        let env1' = StringMap.add x1 x2 env1 in
        let env2' = StringMap.add x2 x1 env2 in
        aux env1' env2' in1 in2
    | Var v1, Var v2 ->
        (match StringMap.find_opt v1 env1 with
         | Some w -> w = v2
         | None ->
             (match StringMap.find_opt v2 env2 with
              | Some w -> w = v1
              | None -> v1 = v2))
    | _, _ -> false
  in
  aux StringMap.empty StringMap.empty e1 e2

let rename_expr (e : expr) : expr =  (* bound‑vars fresh renaming *)
  let counter = ref 0 in
  let fresh () = incr counter; "#" ^ string_of_int !counter in
  let rec aux env exp =
    match exp with
    | Int _ | Bool _ -> exp
    | Var x ->
        (match StringMap.find_opt x env with
         | Some x' -> Var x'
         | None -> Var x)
    | Binop (op,l,r) -> Binop (op, aux env l, aux env r)
    | If (c,t,f) -> If (aux env c, aux env t, aux env f)
    | Let (x,e1,e2) ->
        let e1' = aux env e1 in
        let x' = fresh () in
        let env' = StringMap.add x x' env in
        Let (x', e1', aux env' e2)
  in
  aux StringMap.empty e

let cp (e : expr) : expr =  (* constant propagation main function *)
  let rec simplify env exp =
    match exp with
    | Int _ | Bool _ -> exp
    | Var x ->
        (match StringMap.find_opt x env with
         | Some v -> v
         | None -> Var x)
    | Binop (op,l,r) ->
        let l' = simplify env l in
        let r' = simplify env r in
        (match l', r' with
         | Int a, Int b ->
             (match op with
              | Add -> Int (a + b)
              | Sub -> Int (a - b)
              | Mult -> Int (a * b)
              | Div -> Int (a / b)
              | Leq -> Bool (a <= b)
              | Eq -> Bool (a = b)
              | _ -> Binop (op, l', r'))
         | Bool a, Bool b ->
             (match op with
              | And -> Bool (a && b)
              | Or -> Bool (a || b)
              | Eq -> Bool (a = b)
              | _ -> Binop (op, l', r'))
         | _ -> Binop (op, l', r'))
    | If (c,t,f) ->
        let c' = simplify env c in
        let t' = simplify env t in
        let f' = simplify env f in
        (match c' with
         | Bool true -> t'
         | Bool false -> f'
         | _ -> If (c', t', f'))
    | Let (x,e1,e2) ->
        let e1' = simplify env e1 in
        (match e1' with
         | Int _ | Bool _ ->
             let env' = StringMap.add x e1' env in
             simplify env' e2
         | _ ->
             let env' = StringMap.add x (Var x) env in
             let e2' = simplify env' e2 in
             Let (x, e1', e2'))
  in
  simplify StringMap.empty e

let interp (s : string) : value =
  eval (parse s)
