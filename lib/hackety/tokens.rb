module Hackety

  ## Token Class
  #
  # Represents a terminal in the grammer. We only support two kinds at
  # the moment, integers and operators.

  class Token

    attr_reader :type, :value

    ## Create a Token from a String

    def initialize(t)
      if t =~ /[a-z_]+/
        @type = :identifier
        @value = t
      elsif t =~ /\d+/
        @type = :number
        @value = t.to_i
      else
        @type = t.to_sym
        @value = t.to_sym
      end
    end

    def to_s
      "Token<#{type},#{value}>"
    end
  end

  ## End of File Token
  #
  # This token is returned indefinitely when there are no more tokens in
  # a TokenStream

  class EOFToken < Token
    
    def initialize
      @type = :EOF
      @value = :EOF
    end
  end

  class ParseError < RuntimeError
    
    def initialize(expected, found)
      super "parse error: expected #{expected} but found #{found}"
    end
  end

  ## Token Stream
  #
  # A sequence of token objects, with one character look-ahead. A Parser
  # obejct consumes one of these when generating a parse tree.

  class TokenStream

    def initialize(string)
      @iter = string.split(/\b|\s+/).keep_if { |t| t.strip != "" }.map { |t| Token.new t.strip }.each
      @current_token = nil
    end

    ## Peek At the Next Token
    #
    # Returns the token at the head of the stream, without removing it

    def peek
      @current_token ||= @iter.next
    rescue IndexError
      @current_token = EOFToken.new
    ensure
      @current_token
    end

    ## Check for Token Match
    #
    # Returns true if the next token has the rquired value
    def match(type)
      return peek.type == type
    end

    ## Chomp The Next Token
    #
    # Eats up a Token of input, making sure that it is the rquired type

    def chomp(type)
      cur = peek
      raise ParseError.new type, cur if cur.type != type
      @current_token = nil
      cur
    end
  end

end
