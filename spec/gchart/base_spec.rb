require File.expand_path("#{File.dirname(__FILE__)}/../helper")

describe GChart::Base do
  it "can be initialized with a hash" do
    GChart::Base.new(:title => "foo").title.should == "foo"
  end

  it "complains about being initialized with unknown attributes" do
    lambda { GChart::Base.new(:monkey => :chimchim) }.should raise_error(NoMethodError)
  end

  it "can be initialized with a block" do
    chart = GChart::Base.new do |c|
      c.title = "foo"
    end

    chart.title.should == "foo"
  end
end

describe GChart::Base, "#data" do
  it "is an empty array by default" do
    GChart::Base.new.data.should == []
  end
end

describe GChart::Base, "#size" do
  before(:each) { @chart = GChart::Base.new }
  
  it "can be accessed as width and height" do
    @chart.width.should_not be_zero
    @chart.height.should_not be_zero
  end
  
  it "can be accessed as a combined size" do
    @chart.size.should == "#{@chart.width}x#{@chart.height}"
  end
  
  it "can be specified as a combined size" do
    @chart.size = "11x13"
    @chart.width.should == 11
    @chart.height.should == 13
  end
  
  it "has a reasonable default value" do
    @chart.size.should == "300x200"
  end
  
  it "complains about negative numbers" do
    lambda { @chart.size = "-15x13" }.should raise_error(ArgumentError)
    lambda { @chart.width = -1 }.should raise_error(ArgumentError)
    lambda { @chart.height= -1 }.should raise_error(ArgumentError)
  end
end

describe GChart::Base, "#render_chart_type" do
  it "raises; subclasses must implement" do
    lambda { GChart::Base.new.render_chart_type }.should raise_error(NotImplementedError)
  end
end

describe GChart::Base, "#query_params" do
  before(:each) do
    @chart = GChart::Base.new
    @chart.stub!(:render_chart_type).and_return("TEST")
  end
  
  it "contains the chart's type" do
    @chart.query_params["cht"].should == "TEST"
  end
  
  it "contains the chart's data" do
    @chart.data = [[1, 2, 3], [3, 2, 1]]
    @chart.query_params["chd"].should == "e:VVqq..,..qqVV"
  end
  
  it "contains the chart's size" do
    @chart.query_params["chs"].should == "300x200"
  end
  
  it "contains the chart's title" do
    @chart.title = "foo"
    @chart.query_params["chtt"].should == "foo"
  end
  
  it "escapes the chart's title" do
    @chart.title = "foo bar"
    @chart.query_params["chtt"].should == "foo+bar"
    
    @chart.title = "foo\nbar"
    @chart.query_params["chtt"].should == "foo|bar"
  end
  
  it "contains the chart's colors" do
    @chart.colors = ["cccccc", "eeeeee"]
    @chart.query_params["chco"].should == "cccccc,eeeeee"
  end
end
