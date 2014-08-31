#! /usr/bin/env ruby

class Token

  attr_reader :type, :value

  def initialize(t)
     if t =~ /-?\d+/
       @type = :number
       @value = t.to_i
     else
       @type = :operator
       @value = t.to_sym
     end
  end

  def to_s
    "Token<#{type},#{value}>"
  end
end

class TokenStream

  include Enumerable

  def initialize(string)
    @tokens = string.split.map { |t| Token.new t }
  end

  def each
    @tokens.each { |t| yield t }
  end
end

class Parser

  def self.parse(block)
    ts = TokenStream.new block

    parse_stream ts
  end

  def self.parse_stream ts
    ts.each do |token|
      puts token
    end
  end

end

Parser.parse $*.join(" ")
