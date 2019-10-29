grammar AspCore2ILFGrammar;

WS : ( ' ' | '\t' | '\r' | '\n') -> skip;

DIGIT : [0-9];
ANNOTATION_START : '%**';
ANNOTATION_END : '**%';
RULE : 'rule';
RULES: 'rules';
BLOCK : 'block';
NAME : 'name';
TEST : 'test';
CONSTRAINT: 'constraint';
SCOPE : 'scope';
PROGRAM_FILES: 'programFiles';
INPUT : 'input';
INPUT_FILES : 'inputFiles';
ASSERT : 'assert';
ATOMS : 'atoms';
COST : 'cost';
LEVEL : 'level';
PROGRAM : 'program';
ADD_FILES: 'additionalFiles';
NUM_STR : 'number';
ASSERT_NAS : 'noAnswerSet';
ASSERT_TIA : 'trueInAll';
ASSERT_TIAL : 'trueInAtLeast';
ASSERT_TIAM : 'trueInAtMost';
ASSERT_TIE : 'trueInExactly';
ASSERT_FIA : 'falseInAll';
ASSERT_FIAL : 'falseInAtLeast';
ASSERT_FIAM : 'falseInAtMost';
ASSERT_FIE : 'falseInExactly';
ASSERT_C : 'constraintForAll';
ASSERT_CIE : 'constraintInExactly';
ASSERT_CIAL : 'constraintInAtLeast';
ASSERT_CIAM : 'constraintInAtMost';
ASSERT_BMC : 'bestModelCost';

UPPERLETTER : [A-Z];
LOWERLETTER: [a-z];
NAF: 'not';
ID: LOWERLETTER (UPPERLETTER | LOWERLETTER | NUMBER | '_')*;
VARIABLE: UPPERLETTER (UPPERLETTER | LOWERLETTER | NUMBER | '_')*;
STRING: '\''  ~('\n' | '\r' | '\'')*  '\'';
NUMBER: (DIGIT)+ ;
ANONYMOUS_VARIABLE : '_' ;
DOT: '.';
COMMA: ',';
QUERY_MARK: '?';
COLON: ':';
SEMICOLON: ';';
OR: '|';
CONS: ':-';
WCONS: ':~';
PLUS: '+';
MINUS: '-';
TIMES: '*';
DIV: '/';
AT: '@';
PAREN_OPEN: '(';
PAREN_CLOSE: ')';
SQUARE_OPEN: '[';
SQUARE_CLOSE: ']';
CURLY_OPEN: '{';
CURLY_CLOSE: '}';
EQUAL: '=';
UNEQUAL: '<>' | '!=';
LESS: '<';
GREATER: '>';
LESS_OR_EQ: '<=';
GREATER_OR_EQ: '>=';
AGGREGATE_COUNT: '#count';
AGGREGATE_SUM: '#sum';
AGGREGATE_MAX: '#max';
AGGREGATE_MIN: '#min';
MAXIMIZE: '#maximize';
MINIMIZE: '#minimize';

COMMENT: '%' ~('*') ~('\n' | '^')* (('\n'|'^')?);
MULTI_LINE_COMMENT_START: '%*' ~('*');
MULTI_LINE_COMMENT_END: '*%';
MULTI_LINE_COMMENT: MULTI_LINE_COMMENT_START ~('%')* MULTI_LINE_COMMENT_END;


aspCore2ILFGrammar
    : program
    ;

program
    : statements? query? EOF
    ;

statements
    : statement statements?
    ;

query
    : classicalLiteral QUERY_MARK
    ;

statement
    : annotation
    | comment
    | CONS body? DOT // integrity constraint
    | head (CONS body?)? DOT // rule/fact
    | WCONS body? DOT SQUARE_OPEN weightAtLevel SQUARE_CLOSE
    | optimize DOT
    ;

comment
    : MULTI_LINE_COMMENT
    | COMMENT
    ;

head
    : disjunction
    | choice
    ;

body
    :   (
            nafLiteral 
            | (nafAggregate | aggregate)
        )
        (COMMA body)?
    ;

disjunction
    : classicalLiteral (OR disjunction)?
    ;

choice
    : (term binop) ? CURLY_OPEN choiceElements? CURLY_CLOSE (binop term)?
    ;

choiceElements
    : choiceElement (SEMICOLON choiceElements)?
    ;

choiceElement
    : atom (COLON nafLiterals?)?
    ;

nafAggregate
    : NAF? (term negativeBinop)? aggregateDefinition (negativeBinop term)?
    ;

aggregate
    : (term EQUAL)? aggregateDefinition (EQUAL term)?
    ;

aggregateDefinition
    : aggregateFunction CURLY_OPEN aggregateElements CURLY_CLOSE
    ;

aggregateElements
    : aggregateElement (SEMICOLON aggregateElements)?
    ;

aggregateElement
    : basicTerms? (COLON nafLiterals?)?
    ;

aggregateFunction
    : AGGREGATE_COUNT
    | AGGREGATE_MAX
    | AGGREGATE_MIN
    | AGGREGATE_SUM
    ;

optimize
    : optimizeFunction CURLY_OPEN optimizeElements? CURLY_CLOSE
    ;

optimizeElements
    : optimizeElement (SEMICOLON optimizeElements)?
    ;

optimizeElement
    : weightAtLevel (COLON nafLiterals?)?
    ;

optimizeFunction
    : MAXIMIZE
    | MINIMIZE
    ;

weightAtLevel
    : weakTerm  (AT weakTerm)? (COMMA weakTerms)?
    ;

nafLiterals
    : nafLiteral (COMMA nafLiterals)?
    ;

nafLiteral
    : nafClassicalLiteral
    | classicalLiteral
    |   (NAF? negativeBuiltinAtom | builtinAtom)
    ;

nafClassicalLiteral
    : NAF classicalLiteral
    ;

classicalLiteral
    : MINUS? atom
    ;

atom
    : atomName (PAREN_OPEN terms? PAREN_CLOSE)
    ;

negativeBuiltinAtom
    : term negativeBinop term
    ;

builtinAtom
    : term EQUAL term
    ;

negativeBinop
    : UNEQUAL
    | LESS
    | GREATER
    | LESS_OR_EQ
    | GREATER_OR_EQ
    ;

binop
    : EQUAL
    | UNEQUAL
    | LESS
    | GREATER
    | LESS_OR_EQ
    | GREATER_OR_EQ
    ;

terms
    : term COMMA terms
    ;

term
    : (atomName PAREN_OPEN terms? PAREN_CLOSE)
    | basicTerm
    | (PAREN_OPEN term PAREN_CLOSE)
    | (MINUS term)
    ;

groundTerm
    : ID
    | NUMBER
    | STRING
    ;

variableTerm
    : VARIABLE
    | ANONYMOUS_VARIABLE
    ;

basicTerms
    : basicTerm (COMMA basicTerms)?
    ;

basicTerm
    : groundTerm
    | variableTerm
    ;

weakTerms
    : weakTerm (COMMA weakTerms)?
    ;

weakTerm
    : term
    | basicTerm
    ;

arithop
    : PLUS
    | MINUS
    | TIMES
    | DIV
    ;

atomName
    : ID
    ;


