require File.dirname(__FILE__) + "/version"

require "open-uri"
require "uri"

class GChart
  URL   = "http://chart.apis.google.com/chart"
  TYPES = %w(line linexy bar pie pie3d venn scatter).collect { |t| t.to_sym }
  CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-.".split("")
  PAIRS = CHARS.collect { |first| CHARS.collect { |second| first + second } }.flatten

  class << self
    def encode_extended(number) #:nodoc:
      return "__" if number.nil?
      PAIRS[number.to_i]
    end
    
    TYPES.each do |type|
      class_eval <<-END, __FILE__, __LINE__
        def #{type}(options={}, &block)
          new(options.merge(:type => #{type.inspect}, &block))
        end
      END
    end
  end

  # Array of chart data
  attr_accessor :data
  
  # Hash of additional query params
  attr_accessor :extras
  
  # Width (in pixels)
  attr_accessor :width
  
  # Height (in pixels)
  attr_accessor :height
  
  # Orientation. Applies to bar charts
  attr_accessor :horizontal
  
  # Grouping. Applies to bar charts
  attr_accessor :grouped
  
  # Overall chart title
  attr_accessor :title
  
  # Array of RRGGBB colors, one per data set
  attr_accessor :colors
  
  # Array of data set labels
  attr_accessor :labels
  
  attr_accessor :max
  
  # The chart type
  attr_reader :type
  
  alias_method :horizontal?, :horizontal
  alias_method :grouped?, :grouped
  
  def initialize(options={}, &block)
    @type = :line
    @data = []
    @extras = {}
    @width = 300
    @height = 200
    @horizontal = false
    @grouped = false
    
    options.each { |k, v| send("#{k}=", v) }
    yield(self) if block_given?
  end

  # Sets the chart type. Raises +ArgumentError+ if +type+ isn't in +TYPES+.
  def type=(type)
    unless TYPES.include?(type)
      raise ArgumentError, %Q(Invalid type #{type.inspect}. Valid types: #{TYPES.inspect}.)
    end
    
    @type = type
  end
  
  # Returns the chart's size as "WIDTHxHEIGHT".
  def size
    "#{width}x#{height}"
  end
  
  # Sets the chart's size as "WIDTHxHEIGHT".
  def size=(size)
    self.width, self.height = size.split("x").collect { |n| Integer(n) }
  end
  
  # Returns the chart's URL.
  def to_url
    query = google_query_params.collect { |k, v| "#{k}=#{URI.escape(v)}" }.join("&")
    "#{URL}?#{query}"
  end
  
  # Returns the chart's generated PNG as a blob.
  def fetch
    open(to_url) { |data| data.read }
  end
  
  # Writes the chart's generated PNG to a file. If +io_or_file+ quacks like an IO,
  # +write+ will be called on it instead.
  def write(io_or_file="chart.png")
    return io_or_file.write(fetch) if io_or_file.respond_to?(:write)
    open(io_or_file, "w+") { |f| f.write(fetch) }
  end
  
  private
  
  def google_query_params
    params = { "cht" => google_chart_type, "chd" => google_data, "chs" => size }
    params["chtt"] = title.tr("\n", "|").gsub(/\s+/, "+") if title
    params["chco"] = colors.join(",") if colors
    
    if labels
      param = (type == :pie || type == :pie3d) ? "chl" : "chdl"
      params[param] = labels.join("|")
    end
    
    params.merge(extras)
  end
  
  def google_chart_type
    case type
    when :line
      "lc"
    when :linexy
      "lxy"
    when :bar
      "b" + (horizontal? ? "h" : "v") + (grouped? ? "g" : "s")
    when :pie
      "p"
    when :pie3d
      "p3"
    when :venn
      "v"
    when :scatter
      "s"
    end
  end
  
  def google_data
    raw = data && data.first.is_a?(Array) ? data : [data]
    max = self.max || raw.collect { |s| s.max }.max
    
    sets = raw.collect do |set|
      # we'll just always use the extended encoding for now
      set.collect { |n| GChart.encode_extended(n * (PAIRS.size - 1) / max) }.join
    end
    
    "e:#{sets.join(",")}"
  end  
end
