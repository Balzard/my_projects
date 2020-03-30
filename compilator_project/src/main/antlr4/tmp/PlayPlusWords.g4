lexer grammar PlayPlusWords;

// White space
WHITESPACE: [ \t\r\n]+ -> skip;
// Comments
LINE_COMMENT: '//' .*? '\r'? '\n' -> skip;
COMMENT: '/*' .*? '*/' -> skip;

// ActionType
LEFT:'left';
RIGHT:'right';
UP:'up';
DOWN:'down';
DIG:'dig';
JUMP:'jump';
FIGHT:'fight';

// Map description
SYMBOLES: AT | X | G | P | A | B | T | S | UNDERSCORE| Q;
fragment AT: '@';
fragment X : 'X';
fragment G: 'G';
fragment P: 'P';
fragment A: 'A';
fragment B: 'B';
fragment T: 'T';
fragment S: 'S';
fragment UNDERSCORE: '_';
fragment Q: 'Q';

// Basic operators
AFFECT:':=';
DIVIDE:'/';
PLUS:'+';
MINUS:'-';
ASTERISK:'*';
MODULO:'%';

// Integers and digits
NUMBER: (DIGIT)+;
fragment DIGIT: '0'..'9';

// Program words
AS:'as';
DIES:'#';
IMPORT :'import';
DOTE:'.';
MAP:'map';
BEGIN:'begin';
END:'end';
CONST: 'const';
ENUM:'enum';
FUNCTION:'function';
MAIN:'main';

// Composed Instructions (Conditional, Loop)
IF:'if';
THEN:'then';
ELSE:'else';
WHILE:'while';
REPEAT:'repeat';
FOR:'for';
DO:'do';
UNTIL:'until';
TO:'to';

// Basic symbols
// L, R respectively stans for Left and Right
LPAR:'(';
RPAR:')';
LBRACKET:'[';
RBRACKET:']';
LBRACE:'{';
RBRACE:'}';
COMMA:',';
COLON:':';
SEMICOLON:';';
QUOTE:'"';
SQUOTE:'\'';
AMPERSAND:'&';
BACKSLASH:'\\';

FILENAME: QUOTE ID DOTE MAP QUOTE;

// Boolean operators
EQUAL:'=';
AND:'and';
OR:'or';
SMALLER:'<';
BIGGER:'>';
SMALLEROREQUAL:'<=';
BIGGEROREQUAL:'>=';
DIFFERENT:'!=';
NOT:'not';



// TYPES



// Primitive types
TRUE:'true';
FALSE:'false';
STR: 'string';
BOOL:'boolean';
INT:'integer';
CHAR:'char';
VOID : 'void';
STRUCT: 'struct';
RECORD: 'record';

// Character
CHARACTER: SQUOTE (DIGIT | LETTER | COLON | DOTE | AMPERSAND | DIVIDE | BACKSLASH | SEMICOLON)? SQUOTE;
// String
STRING : QUOTE (ESC|.)*? QUOTE;
fragment ESC: '\\' [btnr"\\];

// Identifier
ID: LETTER (LETTER | DIGIT)*;
fragment LETTER: ('a'..'z'|'A'..'Z'|'_');