import { AspCore2ILFGrammarVisitor } from './grammar/parser/AspCore2ILFGrammarVisitor';
import { ParseTreeVisitor } from 'antlr4ts/tree/ParseTreeVisitor';
import { AspCore2ILFGrammarParser } from './grammar/parser/AspCore2ILFGrammarParser';
import { AspCore2ILFGrammarLexer } from './grammar/parser/AspCore2ILFGrammarLexer';
import { ANTLRInputStream, CommonTokenStream } from 'antlr4ts';

export const Greeter = (name: string) => `Hello ${name}`;


export class AspCore2ILFParser{

    public parse(code: string) : void {
        const inputStream = new ANTLRInputStream(code);
        const lexer = new AspCore2ILFGrammarLexer(inputStream);
        const tokenStream = new CommonTokenStream(lexer);
        const parser = new AspCore2ILFGrammarParser(tokenStream);

        const tree = parser.aspCore2ILFGrammar();
    }
}