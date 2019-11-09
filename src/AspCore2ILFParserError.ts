export interface IAspCore2ILFParserError {
  offendingSymbol: string;
  line: number;
  charPositionInLine: number;
  msg: string;
  e: any;
}
