require File.expand_path("#{File.dirname(__FILE__)}/../helper")

describe GChart::Bar do
  before(:each) do
    @chart = GChart::Bar.new
  end
  
  it "is ungrouped by default" do
    @chart.grouped.should == false
    @chart.should_not be_grouped
  end
  
  it "is horizontal by default" do
    @chart.orientation.should == :horizontal
    @chart.should be_horizontal
    @chart.should_not be_vertical
  end
  
  it "renders the correct chart type" do
    GChart::Bar.new.render_chart_type.should == "bhs"
    GChart::Bar.new(:grouped => true).render_chart_type.should == "bhg"
    GChart::Bar.new(:orientation => :vertical).render_chart_type.should == "bvs"
  end
end
