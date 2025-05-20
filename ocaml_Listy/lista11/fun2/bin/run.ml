open Printf
open Fun               (* parasolka biblioteki *)
open Lexing

let () =
  if Array.length Sys.argv <> 2 then
    (eprintf "Usage: %s file.fun\\n" Sys.argv.(0); exit 1);
  let fname = Sys.argv.(1) in
  let ch = open_in fname in
  let raw =
    Parser.main Lexer.read (from_channel ch) in
  close_in ch;
  try
    let _ = TypeCheck.check_program raw in
    printf "✓ no type errors\\n"
  with
  | TypeCheck.Type_errors lst ->
      List.iter (fun ((p,_),msg) ->
        printf "Line %d, col %d: %s\\n"
          p.pos_lnum (p.pos_cnum - p.pos_bol) msg) lst
  | TypeCheck.Type_error ((p,_), msg) ->
      printf "Line %d, col %d: %s\\n"
        p.pos_lnum (p.pos_cnum - p.pos_bol) msg
