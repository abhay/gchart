module GChart
  class Bar < GChart::Base
    #   # Orientation. Applies to bar charts
    #   attr_accessor :horizontal
    #   
    #   # Grouping. Applies to bar charts
    #   attr_accessor :grouped
    #   
    #   alias_method :horizontal?, :horizontal
    #   alias_method :grouped?, :grouped
    
    # assert_equal("bhg", GChart.new(:type => :bar, :horizontal => true, :grouped => true).google_chart_type)
    # assert_equal("bhs", GChart.new(:type => :bar, :horizontal => true, :grouped => false).google_chart_type)
    # assert_equal("bvs", GChart.new(:type => :bar, :horizontal => false, :grouped => false).google_chart_type)
    
    # def render_chart_type #:nodoc:
    #   "lxy"
    # end
  end
end
