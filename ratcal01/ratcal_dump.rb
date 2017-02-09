#!/usr/pkg/bin/ruby -Ku
# -*- coding: utf-8 -*-

require 'ratcal_parser'
require 'prettyprint'

module Ratcal
  class Sentence
    def dump
      $stdout << PrettyPrint.format('', 10 ) do |pp|
        s = 'S '
        s += ". " if @approximate
        s += "#{@left.name} = " if @left

        pp.text(s)
        pp.nest(s.size) do
          @right.dump(pp)
        end
      end << "\n"
    end
  end

  class Number
    def dump(pp)
      pp.text(@value.to_s)
    end
  end

  class Variable
    def dump(pp)
      pp.text(@name.to_s)
    end
  end

  class UnaryExpr
    def dump(pp)
      pp.text(@type + ' ')
      pp.nest(@type.size + 1) do
        @child.dump(pp)
      end
    end
  end

  class BinaryExpr
    def dump(pp)
      pp.text(@type + ' ')
      pp.nest(@type.size + 1) do
        @left.dump(pp)
        pp.breakable
        @right.dump(pp)
      end
    end
  end
end


if __FILE__ == $0
  include Ratcal

  def test(stream)
    parser = Parser.new(stream)
    while (s = parser.parse)
      s.dump
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
