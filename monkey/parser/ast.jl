import Base

abstract type Node end
abstract type Statement <: Node end

struct Expression <: Node end
struct Identifier <: Node
    token::Token
end

struct LetStatement <: Statement
    token::Token
    identifier::Identifier
    expression::Expression
end

struct ReturnStatement <: Statement
    token::Token
    expression::Expression
end

struct Program
    statements::Array{Statement}
end
Program() = Program([])

INDNT = "  "

function treepr(io::IO, item, indent = 1)
    prefix = INDNT^indent
    if typeof(item) == ReturnStatement
        println(io, prefix, "ReturnStatement(")
        treepr(io, item.token, indent + 1)
        treepr(io, item.expression, indent + 1)
        println(io, prefix, ")")
    elseif typeof(item) == Token
        println(io, prefix, item)
    elseif typeof(item) == LetStatement
        println(io, prefix, "LetStatement(")
        treepr(io, item.token, indent + 1)
        treepr(io, item.identifier, indent + 1)
        treepr(io, item.expression, indent + 1)
        println(io, prefix, ")")
    elseif typeof(item) == Identifier
        println(io, prefix, "Identifier(", item.token, ")")
    elseif typeof(item) == Expression
        println(io, prefix, "Expression()")
    end
end

function Base.show(io::IO, prog::Program)
    println(io, "MonkeyProgram(")
    for stmt in prog.statements
        treepr(io, stmt)
    end
    print(io, ")")
end