import { IAspCore2ILFParserError } from './AspCore2ILFParserError';
import { IAspCore2ILFParserErrorListener } from './IAspCore2ILFParserErrorListener';

export class AspCore2ILFParserDefaultErrorListener implements IAspCore2ILFParserErrorListener {
  private _errors: string[] = [];
  public get errors(): string[] {
    return this._errors;
  }

  public handleError(error: IAspCore2ILFParserError): void {
    this._errors.push(`line ${error.line}:${error.charPositionInLine} ${error.msg}`);
  }

  public clearErrors() {
    this._errors = [];
  }
}
