import { AspCore2ILFParser } from './../../AspCore2ILFParser';

function exec() {
    const parser = new AspCore2ILFParser();
    
    parser.parse(':-color(red).');
}

exec();