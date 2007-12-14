require File.expand_path("#{File.dirname(__FILE__)}/helper")

describe GChart do
  it "supplies a version" do
    GChart::VERSION.should_not be_nil
  end
end

describe GChart, ".encode" do
  it "only supports the extended encoding" do
    lambda { GChart.encode(:simple, 4, 10) }.should raise_error(ArgumentError)
  end

  it "implements the extended encoding" do
    expected = {
      0 => "AA", 25 => "AZ", 26 => "Aa", 51 => "Az", 52 => "A0", 61 => "A9", 62 => "A-", 63 => "A.",
      64 => "BA", 89 => "BZ", 90 => "Ba", 115 => "Bz", 116 => "B0", 125 => "B9", 126 => "B-", 127 => "B.",
      4032 => ".A", 4057 => ".Z", 4058 => ".a", 4083 => ".z", 4084 => ".0", 4093 => ".9", 4094 => ".-", 4095 => ".."
    }
    
    expected.each do |original, encoded|
      GChart.encode(:extended, original, 4095).should == encoded
    end
  end
  
  it "encodes nil correctly" do
    GChart.encode(:extended, nil, 1).should == "__"
  end
end

describe GChart, ".line" do
  it "can render a basic line URL" do
    expected = { "cht" => "lc", "chs" => "300x200", "chd" => "e:AAAo..", "chtt" => "test" }
    chart = GChart.line(:title => "test", :data => [1, 100, 10000])

    chart.query_params.should == expected
    chart.to_url.should == "http://chart.apis.google.com/chart?chs=300x200&cht=lc&chtt=test&chd=e:AAAo.."
  end
end
