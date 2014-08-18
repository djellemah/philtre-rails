module PhiltreRails
  # Used by order_by helper to generate ordering links.
  class OrderLink
    # expr is a Sequel::SQL::OrderedExpression
    def initialize( expr, active: false )
      @expr = expr
      @active = active
    end

    attr_reader :expr, :active

    # appended to the label
    def icon
      if active
        expr.descending ? '&#9660;' : '&#9650;'
      end
    end

    # class of the generated <a...>
    def css_class
      if active
        expr.descending ? 'descending' : 'ascending'
      end
    end

    # this value ends up in the order array of the parameter hash
    def name
      if active
        expr.descending ? "#{expr.expression}_desc" : "#{expr.expression}_asc"
      else
        expr.expression
      end.to_s
    end
  end
end
