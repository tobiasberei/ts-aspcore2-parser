import { ANTLRInputStream, CommonTokenStream, DiagnosticErrorListener } from 'antlr4ts';
import { AspCore2ILFGrammarLexer } from './parser/AspCore2ILFGrammarLexer';
import { AspCore2ILFGrammarParser } from './parser/AspCore2ILFGrammarParser';

export class AspCore2ILFParser {
  public parse(code: string): void {
    const inputStream = new ANTLRInputStream(code);
    const lexer = new AspCore2ILFGrammarLexer(inputStream);
    const tokenStream = new CommonTokenStream(lexer);
    const parser = new AspCore2ILFGrammarParser(tokenStream);

    parser.addErrorListener(new DiagnosticErrorListener());
    const tree = parser.aspCore2ILFGrammar();
  }
}