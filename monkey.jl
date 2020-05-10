include("monkey/monkey.jl")
using .Monkey

data = String(read("program.monkey"))
lexer = Lexer(data)
parser = Parser(lexer)
