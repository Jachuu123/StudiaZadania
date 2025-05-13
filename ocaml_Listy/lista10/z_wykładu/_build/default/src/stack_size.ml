open Rpn

exception Ill_typed_stack of string

let cmd_effect = function
  | PushInt _ | PushBool _ | PushUnit | Load _          -> ( +1, `Seq )
  | Binop _ | PushPair                                  -> ( -1, `Seq )
  | Fst | Snd | IsPair                                  -> (  0, `Seq )
  | Store                                               -> ( -1, `Seq )
  | CleanUp                                             -> (  0, `Seq )
  | CndJmp (t,e)                            -> ( -1, `Br (t,e) )

let rec size_prog prog depth_now =
  let rec loop depth max_seen = function
    | [] -> (max_seen, depth)
    | cmd :: rest ->
        let delta, kind = cmd_effect cmd in
        let depth' = depth + delta in
        if depth' < 0 then raise (Ill_typed_stack "negative stack depth");
        let max_seen' = max max_seen depth' in
        match kind with
        | `Seq ->
            loop depth' max_seen' rest
        | `Br (t,e) ->
            (* obie gałęzie widzą już stos pomniejszony o warunek *)
            let (m1, d1) = size_prog (t @ rest) depth' in
            let (m2, d2) = size_prog (e @ rest) depth' in
            if d1 <> d2 then
              raise (Ill_typed_stack "branches leave different stack depths");
            (max max_seen' (max m1 m2), d1)
  in
  loop depth_now depth_now prog

let stack_size prog =
  let (max_depth, final_depth) = size_prog prog 0 in
  if final_depth <> 1 then
    (* po obliczeniu wartości na stosie powinna zostać jedna wartość *)
    raise (Ill_typed_stack "program leaves non-singleton stack");
  max_depth
