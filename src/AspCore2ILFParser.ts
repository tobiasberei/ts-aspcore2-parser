import { ANTLRInputStream, CommonTokenStream, DiagnosticErrorListener } from 'antlr4ts';
import { IAspCore2ILFParserError } from './AspCore2ILFParserError';
import { AspCore2ILFParserConversionErrorListener } from './AspCore2ILFParserErrorConversionListener';
import { IAspCore2ILFParserErrorListener } from './IAspCore2ILFParserErrorListener';
import { AspCore2ILFGrammarLexer } from './parser/AspCore2ILFGrammarLexer';
import { AspCore2ILFGrammarParser } from './parser/AspCore2ILFGrammarParser';

export class AspCore2ILFParser {
  private _aspCore2ErrorConverter: AspCore2ILFParserConversionErrorListener;

  private _errorListeners: IAspCore2ILFParserErrorListener[] = [];
  public get errorListeners(): IAspCore2ILFParserErrorListener[] {
    return this._errorListeners;
  }

  constructor() {
    this._aspCore2ErrorConverter = new AspCore2ILFParserConversionErrorListener(this, this._handleError);
  }

  public parse(code: string): void {
    const inputStream = new ANTLRInputStream(code);
    const lexer = new AspCore2ILFGrammarLexer(inputStream);
    const tokenStream = new CommonTokenStream(lexer);
    const parser = new AspCore2ILFGrammarParser(tokenStream);

    parser.removeErrorListeners();
    parser.addErrorListener(this._aspCore2ErrorConverter);
    const tree = parser.aspCore2ILFGrammar();
  }

  public addErrorListener(errorListener: IAspCore2ILFParserErrorListener) {
    this.errorListeners.push(errorListener);
  }

  public removeErrorListeners() {
    this._errorListeners = [];
  }

  protected _handleError(context: any, error: IAspCore2ILFParserError): void {
    for (const errListener of context.errorListeners) {
      errListener.handleError(error);
    }
  }
}
