import Base
using Printf

@enum TokenType ILLEGAL = 1 EOF IDENT INT ASSIGN PLUS MINUS BANG ASTERISK SLASH LT GT COMMA SEMICOLON LPAREN RPAREN LBRACE RBRACE FUNCTION LET TRUE FALSE RETURN IF ELSE EQUAL NOTEQUAL LTE GTE

struct Token
  type::TokenType
  literal::String
  line::UInt32
  pos::UInt32
end

Token(type::TokenType, chr::Char, line::UInt32, pos::UInt32) =
  Token(type, String([chr]), line, pos)

function Base.show(io::IO, token::Token)
  str = @sprintf(
    """Token %s("%s") at line %d pos %d""",
    token.type,
    token.literal,
    token.line,
    token.pos
  )
  print(io, str)
end
