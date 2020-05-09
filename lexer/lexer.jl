module Lexer

include("token.jl")

mutable struct MonkeyLexer
    input::String
    pos::UInt32           # current position in input
    line::UInt32          # current line num
    linepos::UInt32       # current position in line
    ch::Char              # current char under examination
end

function MonkeyLexer(input::String)
    ml = MonkeyLexer(input, 0, 1, 0, 0)
    readchar(ml)
    ml
end

function readchar(lx::MonkeyLexer)::Bool
    if lx.pos >= lastindex(lx.input)
        if lx.pos == lastindex(lx.input)
            lx.pos += 1
        end
        lx.ch = 0
        return false
    end

    if lx.ch == '\n'
        lx.linepos = 0
        lx.line += 1
    end

    lx.pos += 1
    lx.linepos += 1

    lx.ch = lx.input[lx.pos]
    true
end

charahead(lx::MonkeyLexer) = lx.pos > lastindex(lx.input) - 1 ? 0 : lx.input[lx.pos + 1]

ident_lookup_table = Dict(
    "fn" => FUNCTION,
    "let" => LET,
    "true" => TRUE,
    "false" => FALSE,
    "return" => RETURN,
    "if" => IF,
    "else" => ELSE
)

symbol_lookup_table = Dict(
    '-' => MINUS,
    '+' => PLUS,
    '/' => SLASH,
    '*' => ASTERISK,
    ',' => COMMA,
    ';' => SEMICOLON,
    '(' => LPAREN,
    ')' => RPAREN,
    '{' => LBRACE,
    '}' => RBRACE,
    '\0' => EOF,
)

identtype(ident::String) = haskey(ident_lookup_table, ident) ? ident_lookup_table[ident] : IDENT
    
function readident(lx::MonkeyLexer)
    pos = lx.pos
    while isletter(lx.ch) && readchar(lx) end
    return lx.input[pos:lx.pos - 1]
end

function readnumeric(lx::MonkeyLexer)
    pos = lx.pos
    while isnumeric(lx.ch) && readchar(lx) end
    return lx.input[pos:lx.pos - 1]
end

function nexttoken(lx::MonkeyLexer)::Token
    local tok::Token

    # skip all whitespaces
    while isspace(lx.ch) && readchar(lx) end

    if haskey(symbol_lookup_table, lx.ch)
        tok = Token(symbol_lookup_table[lx.ch], lx.ch, lx.line, lx.linepos)
    elseif lx.ch == '='
        if charahead(lx) == '='
            tok = Token(EQUAL, "==", lx.line, lx.linepos)
            readchar(lx)
        else
            tok = Token(ASSIGN, lx.ch, lx.line, lx.linepos)
        end
    elseif lx.ch == '!'
        if charahead(lx) == '='
            tok = Token(NOTEQUAL, "!=", lx.line, lx.linepos)
            readchar(lx)
        else
            tok = Token(BANG, lx.ch, lx.line, lx.linepos)
        end
    elseif lx.ch == '<'
        if charahead(lx) == '='
            tok = Token(LTE, "<=", lx.line, lx.linepos)
            readchar(lx)
        else
            tok = Token(LT, lx.ch, lx.line, lx.linepos)
        end
    elseif lx.ch == '>'
        if charahead(lx) == '='
            tok = Token(GTE, ">=", lx.line, lx.linepos)
            readchar(lx)
        else
            tok = Token(GT, lx.ch, lx.line, lx.linepos)
        end
    else
        if isletter(lx.ch)
            linepos = lx.linepos
            line = lx.line
            ident = readident(lx)
            tok = Token(identtype(ident), ident, line, linepos)
            return tok

        elseif isnumeric(lx.ch)
            linepos = lx.linepos
            line = lx.line
            numeric = readnumeric(lx)
            tok = Token(INT, numeric, line, linepos)
            return tok

        else
            tok = Token(ILLEGAL, lx.ch, lx.line, lx.linepos)
            return tok
        end
    end

    readchar(lx)
    return tok
end

export MonkeyLexer, Token, nexttoken, EOF

end