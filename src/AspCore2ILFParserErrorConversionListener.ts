import { ANTLRErrorListener } from "antlr4ts";
import { IAspCore2ILFParserError } from './AspCore2ILFParserError';

export class AspCore2ILFParserConversionErrorListener implements ANTLRErrorListener<any> {
    
    private _errorHandlerContext: any;
    private _errorHandler: (context: any, error: IAspCore2ILFParserError) => void;

    constructor(errorHandlerContext: any, errorHandler: (context: any, error: IAspCore2ILFParserError) => void) {
        this._errorHandlerContext = errorHandlerContext;
        this._errorHandler = errorHandler;
    }

    /**
     * {@inheritDoc }
     */
    public syntaxError(recognizer: any, offendingSymbol: any, line: any, charPositionInLine: any, msg: any, e: any) {
        this._errorHandler(this._errorHandlerContext, {
            charPositionInLine,
            e,
            line,
            msg,
            offendingSymbol
        } as IAspCore2ILFParserError);
        
    }
}