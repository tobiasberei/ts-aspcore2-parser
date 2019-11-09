import { IAspCore2ILFParserError } from './AspCore2ILFParserError';

export interface IAspCore2ILFParserErrorListener {
  /**
   * Handles errors that occur during parsing ASP Core 2 ILF.
   * @param error Object contains information about the error.
   */
  handleError(error: IAspCore2ILFParserError): void;
}
