enum TokenType {
    case eoi // end of input
    case lp // '('
    case rp // ')'
    case dot // '.'
    case num // <number>
    case sym // <symbol>
    case mt // <empty>
    case err // error
}

func repl_main() {
    var lineBuf = readLine() ?? ""
    var lineTokens: [TokenType]
    while lineBuf != "" {
        lineTokens = tokenize(str: lineBuf)
        print(lineTokens)
        lineBuf = readLine() ?? ""
    }
}

func tokenize(str: String) -> [TokenType] {
    var tokens: [TokenType] = []
    var number: [Character] = []
    var symbol: [Character] = []

    for char in str.characters {
        if char == " " || char == "\n" {
            set_num_sym(tokens: &tokens, num: &number, sym: &symbol)
        } else if char == "(" {
            set_num_sym(tokens: &tokens, num: &number, sym: &symbol)
            tokens.append(TokenType.lp)
        } else if char == ")" {
            set_num_sym(tokens: &tokens, num: &number, sym: &symbol)
            tokens.append(TokenType.rp)
        } else if "0"..."9" ~= char {
            number.append(char)
        } else {
            symbol.append(char)
        }
    }
    set_num_sym(tokens: &tokens, num: &number, sym: &symbol)

    return tokens
}

func set_num_sym(tokens: inout [TokenType], num: inout [Character], sym: inout [Character]) {
    if num.count != 0 {
        if sym.count != 0 {
            tokens.append(TokenType.err)
            num.removeAll()
            sym.removeAll()
        } else {
            tokens.append(TokenType.num)
            num.removeAll()
        }
    }
    if sym.count != 0 {
        tokens.append(TokenType.sym)
        sym.removeAll()
    }
}

repl_main()