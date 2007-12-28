module GChart
  class Pie < GChart::Base
    
    # accepts a single data set for the pie chart. Raises +ArgumentError+ if more than one data set is passed in.
    def data=(data)
      raise ArgumentError, "Pie charts only take one set of data" if data.is_a?(Array) and data.first.is_a?(Array) and data.size > 1
      super(data)
    end
    
    def render_chart_type #:nodoc:
      "p"
    end
    
    def render_legend(params)
      params["chl"] = legend.join("|") if legend
    end
  end
end
