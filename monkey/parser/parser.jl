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
    if p.current.type != IDENT
        throw(DomainError(p.current, "identifier expected"))
    end
    ident = Identifier(p.current)
    advance(p)
    ident
end

function parse_expression(p)
    return Expression()
end

function parse_let(p::Parser)
    token = p.current
    advance(p)
    ident = parse_identifier(p)
    if p.current.type != ASSIGN
        throw(DomainError(p.current, "assignment expected"))
    end
    expr = parse_expression(p)
    while p.current.type != SEMICOLON
        advance(p)
    end
    advance(p)
    return LetStatement(token, ident, expr)
end

function parse_return(p::Parser)
    token = p.current
    advance(p)
    expr = parse_expression(p)
    while p.current.type != SEMICOLON
        advance(p)
    end
    advance(p)
    return ReturnStatement(token, expr)
end

function parse_if(p::Parser)

end

function parse_statement(p::Parser)
    if p.current.type == LET
        stmt = parse_let(p::Parser)
    elseif p.current.type == RETURN
        stmt = parse_return(p::Parser)
    elseif p.current.type == IF
        stmt = parse_if(p::Parser)
    else
        throw(DomainError(p.current, "statement expected"))
    end
    stmt
end

function parse(p::Parser)
    program = Program()
    local stmt::Statement

    while p.current.type != EOF
        push!(program.statements, parse_statement(p))
    end

    program
end
