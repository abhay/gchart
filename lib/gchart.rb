require File.expand_path(File.dirname(__FILE__) + "/version")

%w(base bar line pie pie_3d scatter venn xy_line).each do |type|
  require File.expand_path(File.dirname(__FILE__) + "/gchart/#{type}")
end

module GChart
  URL   = "http://chart.apis.google.com/chart"
  CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-.".split("")
  PAIRS = CHARS.collect { |first| CHARS.collect { |second| first + second } }.flatten

  class << self
    # Convenience constructor for GChart::Line.
    def line(*args, &block); Line.new(*args, &block) end
    
    # Convenience constructor for GChart::XYLine.
    def xyline(*args, &block); XYLine.new(*args, &block) end
    
    # Convenience constructor for GChart::Bar.
    def bar(*args, &block); Bar.new(*args, &block) end    
    
    # Convenience constructor for GChart::Pie.
    def pie(*args, &block); Pie.new(*args, &block) end    
    
    # Convenience constructor for GChart::Pie3D.
    def pie3d(*args, &block); Pie3D.new(*args, &block) end    
    
    # Convenience constructor for GChart::Venn.
    def venn(*args, &block); Venn.new(*args, &block) end    
    
    # Convenience constructor for GChart::Scatter.
    def scatter(*args, &block); Scatter.new(*args, &block) end
    
    # Encode +n+ as a string. +n+ is normalized based on +max+.
    # +encoding+ can currently only be :extended.
    def encode(encoding, n, max)
      unless encoding == :extended
        raise ArgumentError, "unsupported encoding: #{encoding.inspect}"
      end

      return "__" if n.nil?
      PAIRS[(n * (PAIRS.size - 1) / max).to_i]
    end
  end
end
