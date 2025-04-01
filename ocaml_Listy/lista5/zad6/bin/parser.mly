(*definicja nieterminali i określenie tokenów terminali*)
%{
open Ast
%}

%token <float> FLOAT
%token LOG
%token POW
%token PLUS MINUS TIMES DIV
%token LPAREN RPAREN
%token EOF

%start main
%type <expr> main

%left PLUS MINUS
%left TIMES DIV
%right POW
(*im niżej tym większa moc operatora*)

%%

main:
  | expr EOF        { $1 }

expr:
  | expr PLUS term  { Add($1, $3) }
  | expr MINUS term { Sub($1, $3) }
  | term            { $1 }

term:
  | term TIMES power  { Mul($1, $3) }
  | term DIV power    { Div($1, $3) }
  | power             { $1 }

power:
  | power POW unary   { Pow($1, $3) }
  | unary             { $1 }

unary:
  | LOG unary         { Log($2) }
  | factor            { $1 }

factor:
  | FLOAT               { Num($1) }
  | LPAREN expr RPAREN  { $2 }
