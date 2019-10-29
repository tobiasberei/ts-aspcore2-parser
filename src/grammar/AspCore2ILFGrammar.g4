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




/* ANNOTATION GRAMMAR */
annotation
    : ANNOTATION_START annotationList ANNOTATION_END
    ;

annotationList
    : annotationExpression annotationList?
    ;

annotationExpression
    : ruleDefinition
    | blockDefinition
    | testDefinition
    | programDefinition
    ;

ruleDefinition
    : AT RULE PAREN_OPEN NAME EQUAL STRING (COMMA BLOCK EQUAL STRING)? PAREN_CLOSE
    ;

blockDefinition
    : AT BLOCK PAREN_OPEN NAME EQUAL STRING (COMMA RULES EQUAL CURLY_OPEN ruleReferenceList CURLY_CLOSE)? PAREN_CLOSE
    ;

testDefinition
    : AT TEST PAREN_OPEN NAME EQUAL STRING COMMA SCOPE EQUAL CURLY_OPEN referenceList CURLY_CLOSE COMMA 
        (PROGRAM_FILES EQUAL CURLY_OPEN programFilesList CURLY_CLOSE COMMA)?
        (INPUT EQUAL STRING COMMA)?
        (INPUT_FILES EQUAL CURLY_OPEN inputFilesList CURLY_CLOSE COMMA)?
        ASSERT EQUAL CURLY_OPEN assertionList CURLY_CLOSE PAREN_CLOSE
    ;

programDefinition
    : AT PROGRAM PAREN_OPEN NAME EQUAL STRING (COMMA ADD_FILES EQUAL STRING)? PAREN_CLOSE
    ;

ruleReferenceList
    : ruleReference (COMMA ruleReferenceList)?
    ;

ruleReference
    : STRING
    ;

programFilesList
    : programFile (COMMA programFilesList)?
    ;

programFile
    : STRING
    ;

inputFilesList
    : inputFile (COMMA inputFilesList)?
    ;

inputFile
    : STRING
    ;

referenceList
    : reference (COMMA referenceList)?
    ;

reference
    : STRING
    ;

assertionList
    : assertion (COMMA assertionList)?
    ;

assertion
    : AT assertType
    ;

assertType
    : assertNoAnswerSet
    | assertTrueInAll
    | assertTrueInAtLeast
    | assertTrueInAtMost
    | assertTrueInExactly
    | assertFalseInAll
    | assertFalsInAtLeast
    | assertFalseInAtMost
    | assertFalseInExactly
    | assertConstraint
    | assertConstraintInExactly
    | assertConstraintInAtLeast
    | assertConstraintInAtMost
    | assertBestModelCost
    ;


assertNoAnswerSet
    : ASSERT_NAS
    ;

assertTrueInAll
    : ASSERT_TIA PAREN_OPEN ATOMS EQUAL STRING PAREN_CLOSE
    ;

assertTrueInAtLeast
    : ASSERT_TIAL PAREN_OPEN NUM_STR EQUAL NUMBER COMMA ATOMS EQUAL STRING PAREN_CLOSE
    ;

assertTrueInAtMost
    : ASSERT_TIAM PAREN_OPEN NUM_STR EQUAL NUMBER COMMA ATOMS EQUAL STRING PAREN_CLOSE
    ;

assertTrueInExactly
    : ASSERT_TIE PAREN_OPEN NUM_STR EQUAL NUMBER COMMA ATOMS EQUAL STRING PAREN_CLOSE
    ;

assertFalseInAll
    : ASSERT_FIA PAREN_OPEN ATOMS EQUAL STRING PAREN_CLOSE
    ;

assertFalsInAtLeast
    : ASSERT_FIAL PAREN_OPEN NUM_STR EQUAL NUMBER COMMA ATOMS EQUAL STRING PAREN_CLOSE
    ;

assertFalseInAtMost
    : ASSERT_FIAM PAREN_OPEN NUM_STR EQUAL NUMBER COMMA ATOMS EQUAL STRING PAREN_CLOSE
    ;

assertFalseInExactly
    : ASSERT_FIE PAREN_OPEN NUM_STR EQUAL NUMBER COMMA ATOMS EQUAL STRING PAREN_CLOSE
    ;

assertConstraint
    : ASSERT_C PAREN_OPEN CONSTRAINT EQUAL STRING PAREN_CLOSE
    ;

assertConstraintInExactly
    : ASSERT_CIE PAREN_OPEN NUM_STR EQUAL NUMBER COMMA CONSTRAINT EQUAL STRING PAREN_CLOSE
    ;


assertConstraintInAtLeast
    : ASSERT_CIAL PAREN_OPEN NUM_STR EQUAL NUMBER COMMA CONSTRAINT EQUAL STRING PAREN_CLOSE
    ;

assertConstraintInAtMost
    : ASSERT_CIAM PAREN_OPEN NUM_STR EQUAL NUMBER COMMA CONSTRAINT EQUAL STRING PAREN_CLOSE
    ;

assertBestModelCost
    : ASSERT_BMC PAREN_OPEN COST EQUAL NUMBER COMMA LEVEL EQUAL NUMBER PAREN_CLOSE
    ;





