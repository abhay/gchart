require File.dirname(__FILE__) + "/version"
require "uri"

class GChart
  URL   = "http://chart.apis.google.com/chart"
  TYPES = %w(line linexy bar pie venn scatter).collect { |t| t.to_sym }
  CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-.".split("")
  PAIRS = CHARS.collect { |first| CHARS.collect { |second| first + second } }.flatten

  class << self
    def encode_extended(number)
      return "__" if number.nil?
      PAIRS[number.to_i]
    end
  end
  
  # for 1.0:
  #   colors
  #   background
  #
  # fetch()
  # write()
  #
  # for 1.1:
  #   legends
  #   area fills
  
  attr_accessor :data, :width, :height, :horizontal, :grouped, :title
  attr_reader :type
  
  alias_method :horizontal?, :horizontal
  alias_method :grouped?, :grouped
  
  def initialize(options={}, &block)
    @type = :line
    @data = []
    @width = 300
    @height = 200
    @horizontal = true
    @grouped = false
    
    options.each { |k, v| send("#{k}=", v) }
    yield(self) if block_given?
  end

  def type=(type)
    unless TYPES.include?(type)
      raise ArgumentError, %Q(Invalid type "#type". Valid types: #{TYPES.join(", ")}.)
    end
    
    @type = type
  end
  
  def size
    "#{width}x#{height}"
  end
  
  def size=(size)
    self.width, self.height = size.split("x").collect { |n| Integer(n) }
  end
  
  def to_url
    query = google_query_params.collect { |k, v| "#{k}=#{URI.escape(v)}" }.join("&")
    "#{URL}?#{query}"
  end
  
  def fetch
    raise "returns the PNG data as a string"
  end
  
  def write(io_or_file)
    raise "fetches and then writes to io_or_file"
  end
  
  private
  
  def google_query_params
    params = { "cht" => google_chart_type, "chd" => google_data, "chs" => size }
    params["chtt"] = title.tr("\n", "|").gsub(/\s+/, "+") if title
    params
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
    when :venn
      "v"
    when :scatter
      "s"
    end
  end
  
  def google_data
    # we'll just always use the extended encoding for now
    sets = (Array === data.first ? data : [data]).collect do |set|
      max = set.max
      set.collect { |n| GChart.encode_extended(n * (PAIRS.size - 1) / max) }.join
    end
    
    "e:#{sets.join(",")}"
  end  
end
