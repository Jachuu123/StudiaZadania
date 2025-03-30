{
  open Parser
}

rule token = parse
| [' ' '\t' '\n' '\r']  { token lexbuf }

| "log"                 { LOG }
| "e"                   { FLOAT 2.718281828459045 }  (* stała e *)
| ['0'-'9']+ '.' ['0'-'9']* as f { FLOAT (float_of_string f) }
| ['0'-'9']+ as f               { FLOAT (float_of_string f) }

| "**"                  { POW }
| "+"                   { PLUS }
| "-"                   { MINUS }
| "*"                   { TIMES }
| "/"                   { DIV }
| "("                   { LPAREN }
| ")"                   { RPAREN }

| eof                   { EOF }

| _ as c                { failwith (Printf.sprintf "Nierozpoznany znak: %c" c) }
