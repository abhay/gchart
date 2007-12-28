module GChart
  class Bar < GChart::Base
    ORIENTATIONS = [:horizontal, :vertical]
    
    attr_accessor :grouped
    alias_method :grouped?, :grouped
    
    attr_reader :orientation
    
    attr_reader :thickness
    attr_reader :spacing
    
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
    
    def thickness=(thickness)
      raise ArgumentError, "Invalid bar thickness: #{thickness.inspect}" if thickness.nil? || thickness < 1
      @thickness = thickness
    end
    
    def spacing=(spacing)
      raise ArgumentError, "Invalid bar spacing: #{spacing.inspect}" if spacing.nil? || spacing < 1
      @spacing = spacing
    end

    def render_chart_type #:nodoc:
      "b#{@orientation.to_s[0..0]}#{grouped? ? "g" : "s"}"
    end
    
    def render_bar_height(params)
      if !thickness.nil? and !spacing.nil?
        params['chbh'] = "#{thickness},#{spacing}"
      elsif !thickness.nil? and spacing.nil?
        params['chbh'] = "#{thickness}"
      end
    end
  end
end
