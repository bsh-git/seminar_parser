#!/usr/pkg/bin/ruby -Ku
# -*- coding: utf-8 -*-

require 'ratcal_parser'

module Ratcal
  class Environment
    def initialize()
      @variables = Hash.new(0)
    end

    def getval(name)
      return @variables[name]
    end

    def setval(name, val)
      @variables[name] = val
    end
  end

  class Sentence
    def execute(env)
      return unless @right   # nothing to do

      val = @right.execute(env)  # expect Rational class
      if @approximate
        print val.to_f, "\n"
      else
        print val.to_s, "\n"
        if @left
          env.setval(@left.name, val)
        end
      end
    end
  end

  class UnaryExpr
    def execute(env)
      val = @child.execute(env)
      return -val
    end
  end

  class BinaryExpr
    def execute(env)
      left = @left.execute(env)
      right = @right.execute(env)
      case @type
      when '+'
        return left + right
      when '-'
        return left - right
      when '*'
        return left * right
      when '/'
        return Rational(left,right)
      end
      nil    # XXX error handling
    end
  end

  class Number
    def execute(env)
      return @value
    end
  end

  class Variable
    def execute(env)
      return env.getval(@name)
    end
  end
  
end

if __FILE__ == $0
  include Ratcal

  env = Environment.new

  def test(env, stream)
    parser = Parser.new(stream)
    while (s = parser.parse)
      s.execute(env)
    end
  end

  if ARGV.empty?
    test(env, $stdin)
  else
    ARGV.each do |file|
      test(env, open(file, 'r'))
    end
  end

end
