enum TokenType {
    case end // end of input
    case lparen // '('
    case rparen // ')'
    case dot // '.'
    case number(Int) // <number>
    case symbol(String) // <symbol>
    case empty // <empty>
    case err // error
}

func repl_main() {
    print("An S-expression evaluator.")

    var lineBuf = readLine() ?? ""
    var allTokens = [TokenType]()
    while lineBuf != "" {
        allTokens += tokenize(str: lineBuf)
        lineBuf = readLine() ?? ""
    }

    build_cons(tokens: allTokens);

    print(allTokens);

    print("End.")
}

func tokenize(str: String) -> [TokenType] {
    var tokens: [TokenType] = []
    var number: [Character] = []
    var symbol: [Character] = []

    func get_num() -> Int {
        return Int(String(number))!
    }

    func set_num_sym() {
        if number.count != 0 {
            if symbol.count != 0 {
                tokens.append(TokenType.err)
                number.removeAll()
                symbol.removeAll()
            } else {
                tokens.append(TokenType.number(get_num()))
                number.removeAll()
            }
        }
        if symbol.count != 0 {
            tokens.append(TokenType.symbol(String(symbol)))
            symbol.removeAll()
        }
    }

    for char in str.characters {
        switch char {
            case " ", "\n": set_num_sym()
            case "(": 
                set_num_sym()
                tokens.append(TokenType.lparen)
            case ")":
                set_num_sym()
                tokens.append(TokenType.rparen)
            case ".":
                set_num_sym()
                tokens.append(TokenType.dot)
            case "0"..."9": number.append(char)
            default: symbol.append(char)
        }
    }
    set_num_sym()

    return tokens
}

func build_cons(tokens: [TokenType]) {
    var tokens = tokens
    switch tokens[0] {
        case .number:
            // make_number
            print(tokens[0])
        case .symbol:
            // make_symbol
            print(tokens[0])
        default:
    }
}

repl_main()