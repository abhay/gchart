module GChart
  class Pie < GChart::Base
    def render_chart_type #:nodoc:
      "p"
    end
    
    def render_legend(params)
      params["chl"] = legend.join("|") if legend
    end
  end
end
