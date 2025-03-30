{
  open Parser
}

rule token = parse
| [' ' '\t' '\n' '\r']  { token lexbuf }  (* pomijanie białych znaków *)

| ['0'-'9']+ '.' ['0'-'9']* as f {
    FLOAT (float_of_string f)
}
| ['0'-'9']+ as f {
    FLOAT (float_of_string f)
}

(* tutaj pozostałe reguły dla operatorów, nawiasów itd. *)
| '+' { PLUS }
| '-' { MINUS }
| '*' { TIMES }
| '/' { DIV }
| '(' { LPAREN }
| ')' { RPAREN }

| eof { EOF }

| _ as c {
    failwith (Printf.sprintf "Nieoczekiwany znak: %c" c)
}
