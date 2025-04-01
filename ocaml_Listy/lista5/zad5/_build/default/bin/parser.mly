%{
open Ast
%}

%token <float> FLOAT
%token PLUS MINUS TIMES DIV
%token LPAREN RPAREN
%token EOF

%start main
%type <Ast.expr> main

%%

main:
  | expr EOF { $1 }

expr:
  | expr PLUS expr   { Add($1, $3) }
  | expr MINUS expr  { Sub($1, $3) }
  | expr TIMES expr  { Mul($1, $3) }
  | expr DIV expr    { Div($1, $3) }
  | LPAREN expr RPAREN { $2 }
  | FLOAT            { Num($1) }

