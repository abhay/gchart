require "open-uri"
require "uri"

module GChart
  class Base
    # Array of chart data. See subclasses for specific usage.
    attr_accessor :data
    
    # Hash of additional HTTP query params.
    attr_accessor :extras
    
    # Chart title.
    attr_accessor :title
    
    # Array of rrggbb colors, one per data set.
    attr_accessor :colors
    
    # Array of legend text, one per data set.
    attr_accessor :legend
    
    # Max data value for quantization.
    attr_accessor :max

    # Chart width, in pixels.
    attr_reader :width    
    
    # Chart height, in pixels.
    attr_reader :height

    def initialize(options={}, &block)
      @data = []
      @extras = {}
      @width = 300
      @height = 200
  
      options.each { |k, v| send("#{k}=", v) }
      yield(self) if block_given?
    end

    # Sets the chart's width, in pixels. Raises +ArgumentError+ if +width+ is less than 1 or greater than 1,000.
    def width=(width)
      raise ArgumentError, "Invalid width: #{width.inspect}" if width.nil? || width < 1 || width > 1_000
      @width = width
    end

    # Sets the chart's height, in pixels. Raises +ArgumentError+ if +height+ is less than 1 or greater than 1,000.
    def height=(height)
      raise ArgumentError, "Invalid height: #{height.inspect}" if height.nil? || height < 1 || height > 1_000
      @height = height
    end

    # Returns the chart's size as "WIDTHxHEIGHT".
    def size
      "#{width}x#{height}"
    end

    # Sets the chart's size as "WIDTHxHEIGHT". Raises +ArgumentError+ if +width+ * +height+ is greater than 300,000 pixels.
    def size=(size)
      self.width, self.height = size.split("x").collect { |n| Integer(n) }
      raise ArgumentError, "Invalid size: #{size.inspect} requests a graph with more than 300,000 pixels" if (self.width * self.height) > 300_000
    end

    # Returns the chart's URL.
    def to_url
      query = query_params.collect { |k, v| "#{k}=#{URI.escape(v)}" }.join("&")
      "#{GChart::URL}?#{query}"
    end

    # Returns the chart's generated PNG as a blob.
    def fetch
      open(to_url) { |io| io.read }
    end

    # Writes the chart's generated PNG to a file. If +io_or_file+ quacks like an IO,
    # calls +write+ on it instead.
    def write(io_or_file="chart.png")
      return io_or_file.write(fetch) if io_or_file.respond_to?(:write)
      open(io_or_file, "w+") { |io| io.write(fetch) }
    end

    protected
    
    def query_params #:nodoc:
      params = { "cht" => render_chart_type, "chs" => size }
      
      case params["cht"]
      when /b(h|v)(g|s)/
        render_bar_height(params)
      end
    
      render_data(params)
      render_title(params)
      render_colors(params)
      render_legend(params)

      params.merge(extras)
    end

    def render_chart_type #:nodoc:
      raise NotImplementedError, "override in subclasses"
    end
    
    def render_data(params) #:nodoc:
      raw = data && data.first.is_a?(Array) ? data : [data]
      max = self.max || raw.collect { |s| s.max }.max
  
      sets = raw.collect do |set|
        set.collect { |n| GChart.encode(:extended, n, max) }.join
      end
  
      params["chd"] = "e:#{sets.join(",")}"
    end
    
    def render_title(params) #:nodoc:
      params["chtt"] = title.tr("\n ", "|+") if title
    end
    
    def render_colors(params) #:nodoc:
      params["chco"] = colors.join(",") if colors  
    end
    
    def render_legend(params) #:nodoc:
      params["chdl"] = legend.join("|") if legend
    end    
  end
end
