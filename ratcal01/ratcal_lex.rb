#!/usr/pkg/bin/ruby -Ku
# -*- coding: utf-8 -*-

module Ratcal

  IDENTIFIER = 'ID'
  INTEGER = 'NUM'
  EOL = 'EOL'
  OPERATOR = 'OP'
  LPAR = '('
  RPAR = ')'
  ILLEGAL = 'ILL'
  ASSIGN = '='
  DOT = '.'

  class Token
    attr_reader :type, :val
    def initialize(type, val)
      @type = type
      @val = val
    end

    def isOp(v)
      return @type == OPERATOR && @val == v
    end
  end

  class TokenReader
    def initialize(stream)
      @inputSource = stream
      @back = nil
    end

    #
    # 入力ストリームを読んでトークンを1個返す
    #
    def get
      if @back
        ret = @back
        @back = nil
        return ret
      end

      ch = skipBlanks  # 空白を飛ばして一文字取得

      return nil unless ch   # EOFならnil を返す

      if ch == "\n"
        return Token.new(EOL, nil)
      end

      if ch =~ /[[:digit:]]/
        # 数字を見たので、整数トークンを返す
        return integer(ch)
      end

      if ch =~ /[[:alpha:]]|_/
        # 英字を見たので、識別子トークンを返す
        return identifier(ch)
      end

      case ch
      when '='
        return Token.new(ASSIGN, ch);
      when '.'
        return Token.new(DOT, ch);
      when '+', '-', '*', '/'
        return Token.new(OPERATOR, ch);
      when '('
        return Token.new(LPAR, ch)
      when ')'
        return Token.new(RPAR, ch)
      end

      return Token.new(ILLEGAL, ch);
    end

    #
    # 整数
    #
    def integer(ch0)
      val = charToDigit(ch0)
      ch = @inputSource.getc
      while ch =~ /[[:digit:]]/
        val = val * 10 + charToDigit(ch)
        ch = @inputSource.getc
      end

      @inputSource.ungetc(ch)

      return Token.new(INTEGER, val)
    end

    #
    # 識別子
    #
    def identifier(ch0)
      str = ch0
      ch = @inputSource.getc
      while ch =~ /[[:digit:]]|[[:alpha:]]|_/
        str += ch
        ch = @inputSource.getc
      end

      @inputSource.ungetc(ch)

      return Token.new(IDENTIFIER, str)
    end
    #
    # トークンを戻す
    #
    def unget(tok)
      @back = tok
    end

    def charToDigit(ch)
      ch.to_i
    end

    def skipBlanks
      while (ch = @inputSource.getc) =~ /[ \t\r]/
      end
      return ch
    end
  end


end

if __FILE__ == $0
  include Ratcal

  def test(stream)
    reader = TokenReader.new(stream)
    while (tok = reader.get)
      p tok
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
