
discard """
  cmd: '''nim c --gc:arc $file'''
"""

when defined(cpp):
  {.passC: "-std=gnu++2a".}

type
  TokenKind* = enum
    tkColon
    tkComma
    tkString
    tkNumber
    tkInt64
    tkIdent

  Token* = object
    case kind*: TokenKind
    of tkString: strVal*: string
    of tkNumber: numVal*: float
    of tkInt64: int64Val*: int64
    of tkIdent: ident*: string
    else: discard
    pos*: Natural


  Token2* = object
    case kind*: TokenKind
    of tkString: strVal*: string
    of tkNumber: numVal*: float
    of tkInt64, tkColon..tkComma:
      str1*: array[2, string]
      float: float
    else: discard
    pos*: Natural

  Token3* = object
    case kind*: TokenKind
    of tkNumber: numVal*: float
    of tkInt64, tkComma..tkString: ff: seq[float]
    else: str1*: string
  
  BaseLexer* = object of RootObj
    input*: string
    pos*: Natural

  Json5Lexer* = object of BaseLexer

  JsonLexer* = object of BaseLexer
    allowComments*: bool
    allowSpecialFloats*: bool

  Lexer* = Json5Lexer | JsonLexer

  Parser[T: Lexer] = object
    l: T
    tok: Token
    tok2: Token2
    tok3: Token3
    allowTrailingComma: bool
    allowIdentifierObjectKey: bool

proc initJson5Lexer*(input: string): Json5Lexer =
  result.input = input

proc parseJson5*(input: string)  =
  var p = Parser[Json5Lexer](
    l: initJson5Lexer(input),
    allowTrailingComma: true,
    allowIdentifierObjectKey: true
  )


let x = "string"
parseJson5(x)