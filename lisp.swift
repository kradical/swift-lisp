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

// Tracking globals
var lineBuf = [Character]() // current line
var ch: Character? // current char
var tok: TokenType = TokenType.empty// current token

func consume_while(_ condition: (Character?) -> Bool) -> [Character] {
    var characters = [Character]()

    while condition(ch) {
        characters.append(ch!)
        next_char()
    }

    return characters
}

func read_line() {
    if let line = readLine() {
        lineBuf = Array(line.characters)
    }
}

func next_char() {
    if lineBuf.count == 0 {
        read_line()
        if lineBuf.count == 0 {
            ch = nil
        } else {
            ch = lineBuf.remove(at: 0)
        }
    } else {
        ch = lineBuf.remove(at: 0)
    }
}

func is_digit(c: Character) -> Bool {
    return c <= "9" && c >= "0"
}
func is_alpha(c: Character) -> Bool {
    return (c >= "a" && c <= "z") || (c >= "A" && c <= "Z")
}
func is_whitespace(c: Character) -> Bool {
    return c == " " || c == "\n"
}
func wrap_opt(_ f: @escaping (Character) -> Bool) -> (Character?) -> Bool {
    return { 
        if $0 == nil {
            return false 
        } else {
            return f($0!)
        }
    }
}

// setup an unread character before calling this function
// works well with consume_while
func next_token() {
    let _ = consume_while(wrap_opt(is_whitespace))
    if ch == nil {
        tok = TokenType.end
        return
    }

    switch ch! {
    case "(": 
        tok = TokenType.lparen
        next_char()
    case ")":
        tok = TokenType.rparen
        next_char()
    case ".":
        tok = TokenType.dot
    case "0"..."9":
        let number = consume_while(wrap_opt(is_digit))
        tok = TokenType.number(Int(String(number))!)
    default:
        let symbol = consume_while(wrap_opt(is_alpha))
        tok = TokenType.symbol(String(symbol))
    }
}

func is_end(t: TokenType) -> Bool {
    switch t {
        case .end: return true
        default: return false
    }
}

func repl_main() {
    print("An S-expression evaluator.")

    next_char()
    while !is_end(t: tok) {
        print(tok)
        next_token()
    }

    print("End.")
}

repl_main()