module Prattle

  ## Value Expression
  #
  # Represents a simpel number or variable value.
  class ValueExpression
    
    def initialize(value)
      @value = value
    end

    def to_s
      @value.to_s
    end
  end

  ## Prefix Operator Expression

  class PrefixOperatorExpression
    
    def initialize(operator, value)
      @operator = operator
      @value = value
    end

    def to_s
      "(#{@operator}#{@value})"
    end

  end

  ## Binary Operator Expression
  
  class BinaryOperatorExpression
    
    def initialize(lhs, op, rhs)
      @lhs = lhs
      @op = op
      @rhs = rhs
    end

    def to_s
      "(#{@lhs} #{@op} #{@rhs})"
    end
    
  end

end
