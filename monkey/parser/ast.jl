abstract type Node end
abstract type Statement <: Node end

struct Expression <: Node end
struct Identifier <: Node
  identifier::String
end

struct LetStatement <: Statement
  identifier::Identifier
  expression::Expression
end

struct Program
  statements::Array{Statement}
end

Program() = Program([])
