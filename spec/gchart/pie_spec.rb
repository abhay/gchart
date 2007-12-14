require File.expand_path("#{File.dirname(__FILE__)}/../helper")

describe GChart::Pie do
  it "renders the correct chart type" do
    GChart::Pie.new.render_chart_type.should == "p"
  end
end
