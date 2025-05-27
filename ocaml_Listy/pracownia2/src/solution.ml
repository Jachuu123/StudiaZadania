type bop =
  | Add | Sub | Mult | Div
  | And | Or
  | Eq | Neq | Leq | Lt | Geq | Gt 

type ident = string

type expr =
  | Int    of int
  | Binop  of bop * expr * expr
  | Bool   of bool
  | If     of expr * expr * expr
  | Let    of ident * expr * expr
  | Var    of ident
  | Cell   of int * int
  | Unit
  | Pair   of expr * expr
  | Fst    of expr
  | Snd    of expr
  | Match  of expr * ident * ident * expr
  | IsPair of expr
  | Fun    of ident * expr
  | Funrec of ident * ident * expr
  | App    of expr * expr

module StringMap = Map.Make (String)

type value =
  | VInt of int
  | VBool of bool
  | VUnit
  | VPair of value * value
  | VClosure of ident * expr * env
  | VRecClosure of ident * ident * expr * env
and env = value StringMap.t

let env_empty : env = StringMap.empty
let env_add x v env = StringMap.add x v env
let env_find x env =
  try StringMap.find x env with Not_found -> failwith ("unbound variable: " ^ x)

let env_empty : env = StringMap.empty
let env_add x v env = StringMap.add x v env
let env_find x env =
  try StringMap.find x env with Not_found -> failwith ("unbound variable: " ^ x)


let int_binop f v1 v2 =
  match v1, v2 with
  | VInt n1, VInt n2 -> VInt (f n1 n2)
  | _ -> failwith "type error: expected two ints"

let bool_binop f v1 v2 =
  match v1, v2 with
  | VBool b1, VBool b2 -> VBool (f b1 b2)
  | _ -> failwith "type error: expected two bools"

let comp_binop f v1 v2 =
  match v1, v2 with
  | VInt n1, VInt n2 -> VBool (f n1 n2)
  | _ -> failwith "type error: expected two ints for comparison"

let eval_op op v1 v2 =
  match op with
  | Add  -> int_binop ( + ) v1 v2
  | Sub  -> int_binop ( - ) v1 v2
  | Mult -> int_binop ( * ) v1 v2
  | Div  -> int_binop ( / ) v1 v2
  | And  -> bool_binop ( && ) v1 v2
  | Or   -> bool_binop ( || ) v1 v2
  | Eq   -> comp_binop ( = ) v1 v2
  | Neq  -> comp_binop ( <> ) v1 v2
  | Leq  -> comp_binop ( <= ) v1 v2
  | Lt   -> comp_binop ( < ) v1 v2
  | Geq  -> comp_binop ( >= ) v1 v2
  | Gt   -> comp_binop ( > ) v1 v2

let current_cell_lookup : (int -> int -> value) ref =
  ref (fun _ _ -> failwith "Cell reference outside spreadsheet evaluation")

let rec eval (env : env) (e : expr) : value =
  match e with
  | Int n -> VInt n
  | Bool b -> VBool b
  | Binop (op, e1, e2) -> eval_op op (eval env e1) (eval env e2)
  | If (c, t, f) ->
      (match eval env c with
       | VBool true  -> eval env t
       | VBool false -> eval env f
       | _ -> failwith "type error: condition must be bool")
  | Let (x, e1, e2) -> eval (env_add x (eval env e1) env) e2
  | Var x -> env_find x env
  | Pair (e1, e2) -> VPair (eval env e1, eval env e2)
  | Unit -> VUnit
  | Fst e -> (match eval env e with VPair (v, _) -> v | _ -> failwith "type error: fst")
  | Snd e -> (match eval env e with VPair (_, v) -> v | _ -> failwith "type error: snd")
  | Match (e1, x, y, body) ->
      (match eval env e1 with
       | VPair (v1, v2) -> eval (env |> env_add x v1 |> env_add y v2) body
       | _ -> failwith "type error: match expects pair")
  | IsPair e -> VBool (match eval env e with VPair _ -> true | _ -> false)
  | Fun (x, body) -> VClosure (x, body, env)
  | Funrec (f, x, body) -> VRecClosure (f, x, body, env)
  | App (e_fn, e_arg) ->
      let v_fn  = eval env e_fn in
      let v_arg = eval env e_arg in
      (match v_fn with
       | VClosure (x, body, clos_env) -> eval (env_add x v_arg clos_env) body
       | VRecClosure (f, x, body, clos_env) as rc ->
           eval (clos_env |> env_add x v_arg |> env_add f rc) body
       | _ -> failwith "type error: application of non‑function")
  | Cell (r, c) -> (!current_cell_lookup) r c


type cell_state = NotVisited | Visiting | Done of value
exception Cycle

let eval_spreadsheet (sheet : expr list list) : value list list option =
  match sheet with
  | [] -> Some []
  | first_row :: _ ->
      let rows = List.length sheet in
      let cols = List.length first_row in
      if List.exists (fun r -> List.length r <> cols) sheet then
        failwith "ragged spreadsheet";

      let expr_tbl = Array.of_list (List.map Array.of_list sheet) in
      let state_tbl = Array.init rows (fun _ -> Array.make cols NotVisited) in
      let val_tbl   = Array.init rows (fun _ -> Array.make cols VUnit) in

      let rec eval_cell r c : value =
        if r < 0 || r >= rows || c < 0 || c >= cols then
          failwith "cell index out of bounds";
        match state_tbl.(r).(c) with
        | Done v -> v
        | Visiting -> raise Cycle
        | NotVisited ->
            state_tbl.(r).(c) <- Visiting;
            let v = eval env_empty expr_tbl.(r).(c) in
            state_tbl.(r).(c) <- Done v;
            val_tbl.(r).(c) <- v;
            v
      in

      let old_lookup = !current_cell_lookup in
      current_cell_lookup := eval_cell;
      let result =
        (try
           for r = 0 to rows - 1 do
             for c = 0 to cols - 1 do
               ignore (eval_cell r c)
             done
           done;
           let out = Array.to_list (Array.map Array.to_list val_tbl) in
           Some out
         with Cycle -> None)
      in
      current_cell_lookup := old_lookup;
      result


let rec string_of_value = function
  | VInt n -> string_of_int n
  | VBool b -> string_of_bool b
  | VUnit -> "()"
  | VPair (v1, v2) -> "(" ^ string_of_value v1 ^ ", " ^ string_of_value v2 ^ ")"
  | VClosure _ | VRecClosure _ -> "<fun>"
