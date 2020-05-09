include("lexer/lexer.jl")
using .Lexer

data = String(read("program.monkey"))
lexer = MonkeyLexer(data)

while true
    tok = nexttoken(lexer)
    println(tok)
    if tok.type == EOF break end
end
