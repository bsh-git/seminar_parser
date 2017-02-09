#!/usr/pkg/bin/ruby -Ku
# -*- coding: utf-8 -*-

require 'ratcal_lex'

module Ratcal

  class Sentence
    def initialize(approximate, left, right)
      @approximate = approximate  # 近似値表示か？
      @left = left   # 代入文の左辺。 代入文でなければnil
      @right = right   # 式
    end
  end

  # 単項演算   -
  class UnaryExpr
    def initialize(type, child)
      @type = type
      @child = child
    end
  end

  # 二項演算    + - * /
  class BinaryExpr
    def initialize(type, left, right)
      @type = type
      @left = left
      @right = right
    end
  end

  class Number
    def initialize(value)
      @value = value
    end
  end

  class Variable
    attr_reader :name
    def initialize(name)
      @name = name.intern
    end
  end

  class Parser
    def initialize(stream)
      @reader = TokenReader.new(stream)
    end

    def getToken
      tok = @reader.get
      if tok && tok.type == ILLEGAL
        raise SyntaxError, "Unknown character `#{tok.val}'"
      end
      tok
    end

    # 構文解析を実行して、構文木を返す。 ルートは Sentence になるはず
    def parse
      tok = getToken

      return nil unless tok        # EOF

      if tok.type == DOT
        # . コマンド (浮動小数点の近似値を表示)
        expr = getExpr
        s = Sentence.new(true, nil, expr)
        expectEOL
        return s
      else
        @reader.unget(tok)
      end

      expr = getExpr
      return nil unless expr      # 空行だった

      if expr.class == Variable
        tok = getToken
        if tok && tok.type == ASSIGN
          right = getExpr
          s = Sentence.new(false, expr, right)
          expectEOL
          return s
        else
          @reader.unget(tok)
        end
      end

      # 式のみ。計算して結果を表示する
      expectEOL
      return Sentence.new(false, nil, expr)

    end
  end

  # 式をパース
  def getExpr
    # 二項演算以外を処理
    expr = getExpr2
    return nil unless expr

    op = getToken
    if op.type == OPERATOR
      right = getExpr
      unless right
        raise SyntaxError, "missing right hand of #{op.val}"
      end
      return BinaryExpr.new(op.val, expr, right)
    else
      @reader.unget(op)
      return expr
    end
  end

  def getExpr2
    tok = getToken
    if not tok        # EOF
      return nil
    end

    if tok.type == EOL || tok.type == ASSIGN
      @reader.unget(tok)
      return nil
    end

    if tok.type == ILLEGAL
      rais SyntaxError, "Illegal charactor #{tok.val}"
      return nil
    end

    # ( 式 )
    if tok.type == LPAR
      expr = getExpr
      expectRPAR
      return expr
    end

    # 単項マイナス
    if tok.isOp('-')
      return UnaryExpr.new(tok.type, getExpr2)
    end

    # 識別子 : 変数を参照
    if tok.type == IDENTIFIER
      return Variable.new(tok.val)
    end

    if tok.type == INTEGER
      return Number.new(tok.val)
    end

    raise SyntaxError, "Parser error"
  end


  def expectEOL
    tok = getToken
    unless tok.type == EOL
      raise SyntaxError, "EOL is expected, but got #{tok.val}"
    end
  end

  def expectRPAR
    tok = getToken
    unless tok.type == RPAR
      raise SyntaxError, "`)' is expected, but got #{tok.val}"
    end
  end

end

if __FILE__ == $0
  require 'ratcal_lex'
  include Ratcal

  def test(stream)
    parser = Parser.new(stream)
    while (s = parser.parse)
      p s
    end
  end

  if ARGV.empty?
    test($stdin)
  else
    ARGV.each do |file|
      test(open(file, 'r'))
    end
  end
end
