require File.expand_path("#{File.dirname(__FILE__)}/../helper")

describe GChart::Pie do
  it "renders the correct chart type" do
    GChart::Pie.new.render_chart_type.should == "p"
  end
end

describe GChart::Pie, "#query_params" do
  before(:each) { @chart = GChart::Pie.new }
  
  it "contains the chart's type" do
    @chart.query_params["cht"].should == "p"
  end
  
  it "contains the chart's legend" do
    @chart.legend = ["foo"]
    @chart.query_params.keys.include?("chl").should be_true
    @chart.query_params["chl"].should == "foo"
  end
end