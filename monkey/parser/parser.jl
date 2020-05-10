include("ast.jl")

mutable struct Parser
  lexer::Lexer
  current::Token
  next::Token
end

function Parser(lexer::Lexer)
  current = nexttoken(lexer)
  next = nexttoken(lexer)
  Parser(lexer, current, next)
end

function readnext(p::Parser)
  p.current = p.next
  p.next = nexttoken(p.lexer)
end
