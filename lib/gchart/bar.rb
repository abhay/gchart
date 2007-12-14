module GChart
  class Bar < GChart::Base
    ORIENTATIONS = [:horizontal, :vertical]
    
    attr_accessor :grouped
    alias_method :grouped?, :grouped
    
    attr_reader :orientation
    
    def initialize(*args, &block)
      @grouped = false
      @orientation = :horizontal
      super
    end
    
    def orientation=(orientation)
      unless ORIENTATIONS.include?(orientation)
        raise ArgumentError, "Invalid orientation: #{orientation.inspect}. " +
          "Valid orientations: #{ORIENTATIONS.inspect}"
      end
      
      @orientation = orientation
    end
    
    def horizontal?
      @orientation == :horizontal
    end

    def vertical?
      @orientation == :vertical
    end
    
    def render_chart_type #:nodoc:
      "b#{@orientation.to_s[0..0]}#{grouped? ? "g" : "s"}"
    end
  end
end
