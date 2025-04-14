%{
open Ast
%}

%token <bool> BOOL
%token <int> INT
%token <string> IDENT
%token IF
%token THEN
%token ELSE
%token LET
%token IN
%token PLUS
%token MINUS
%token TIMES
%token DIV
%token AND
%token OR
%token EQ
%token LEQ
%token LPAREN
%token RPAREN
%token LSPAREN
%token RSPAREN
%token EOF
%token COMMA
%token UNIT
%token FST
%token SND
%token MATCH
%token WITH
%token ARR
%token IS_NUMBER
%token IS_PAIR
%token IS_BOOL
%token IS_UNIT
%token LBRACKET RBRACKET SEMI
%token FOLD FOLD_AND


%start <Ast.expr> main

%left AND OR
%nonassoc EQ LEQ
%left PLUS MINUS
%left TIMES DIV

%%

main:
    | e = mexpr; EOF { e }
    ;

mexpr:
    | FOLD; e1 = mexpr; WITH; LPAREN; x = IDENT; COMMA; acc = IDENT; RPAREN; ARR; e2 = mexpr; FOLD_AND; e3 = mexpr
          { Fold(e1, x, acc, e2, e3) }
    | IF; e1 = mexpr; THEN; e2 = mexpr; ELSE; e3 = mexpr
        { If(e1, e2, e3) }
    | LET; x = IDENT; EQ; e1 = mexpr; IN; e2 = mexpr
        { Let(x, e1, e2) }
    | MATCH; e1 = mexpr; WITH; LPAREN; x = IDENT; COMMA; y = IDENT; RPAREN; ARR; e2 = mexpr
        { Match(e1, x, y, e2) }
    | LBRACKET list_items RBRACKET   { $2 } 
    | e = expr
        { e }
    ;

list:
    | LBRACKET list_items RBRACKET { $2 }
;

list_items:
    | /* empty */                   { Unit }
    | nonempty_list                 { $1 }
;

nonempty_list:
    | expr                          { Pair($1, Unit) }
    | expr SEMI nonempty_list       { Pair($1, $3) }
;


expr:
    | i = INT { Int i }
    | b = BOOL { Bool b }
    | x = IDENT { Var x }
    | e1 = expr; PLUS; e2 = expr { Binop(Add, e1, e2) }
    | e1 = expr; MINUS; e2 = expr { Binop(Sub, e1, e2) }
    | e1 = expr; DIV; e2 = expr { Binop(Div, e1, e2) }
    | e1 = expr; TIMES; e2 = expr { Binop(Mult, e1, e2) }
    | e1 = expr; AND; e2 = expr { Binop(And, e1, e2) }
    | e1 = expr; OR; e2 = expr { Binop(Or, e1, e2) }
    | e1 = expr; EQ; e2 = expr { Binop(Eq, e1, e2) }
    | e1 = expr; LEQ; e2 = expr { Binop(Leq, e1, e2) }
    | LPAREN; e1 = mexpr; COMMA; e2 = mexpr; RPAREN { Pair (e1,e2) }
    | UNIT { Unit }
    | FST; e = expr { Fst e }
    | SND; e = expr { Snd e }
    | LPAREN; e = mexpr; RPAREN { e }
    | IS_NUMBER; e = expr { IsNum(e )}
    | IS_PAIR; e = expr { IsPair(e) }
    | IS_BOOL; e = expr { IsBool(e) }
    | IS_UNIT; e = expr { IsUnit(e) }
    ;


