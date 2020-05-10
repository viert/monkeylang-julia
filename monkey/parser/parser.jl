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

function advance(p::Parser)
  p.current = p.next
  p.next = nexttoken(p.lexer)
end

function parse_identifier(p::Parser)
end

function parse_let(p::Parser)
  return LetStatement()
end

function parse_return(p::Parser)

end

function parse_if(p::Parser)

end

function parse(p::Parser)
  program = Program()
  local stat::Statement

  while p.current.type != EOF
    if p.current.type == LET
      stat = parse_let(p::Parser)
    elseif p.current.type == RETURN
      stat = parse_return(p::Parser)
    elseif p.current.type == IF
      stat = parse_if(p::Parser)
    else
      throw(DomainError(p.current, "statement expected"))
    end

    push!(program.statements, stat)
    advance(p)
  end

  program
end
