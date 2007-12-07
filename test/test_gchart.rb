require "test/unit"
require "gchart"

class GChart
  public :google_query_params, :google_chart_type, :google_data
end

class TestGChart < Test::Unit::TestCase
  def test_allows_hash_initialization
    assert_equal(:line, GChart.new(:type => :line).type)
  end
  
  def test_complains_about_unknown_options
    assert_raise(NoMethodError) { GChart.new(:monkey => :chimchim) }
  end
  
  def test_allows_block_initialization
    c = GChart.new do |chart|
      chart.type = :line
    end
    
    assert_equal(:line, c.type)
  end
  
  def test_allows_all_valid_chart_types
    GChart::VALID_TYPES.each do |type|
      assert_nothing_raised(ArgumentError) { GChart.new(:type => type) }
    end
  end
  
  def test_complains_about_invalid_chart_types
    assert_raise(ArgumentError) { GChart.new(:type => :monkey) }
  end
  
  def test_allows_size_to_be_specified_combined
    c = GChart.new(:size => "13x14")
    assert_equal(13, c.width)
    assert_equal(14, c.height)
  end
  
  def test_defaults
    c = GChart.new
    assert_equal(:line, c.type)   
    assert_equal([], c.data)
    assert_equal(300, c.width)
    assert_equal(200, c.height)
    assert(c.horizontal?)
    assert(!c.grouped?)
  end
  
  def test_google_chart_types
    assert_equal("lc", GChart.new(:type => :line).google_chart_type)
    assert_equal("lxy", GChart.new(:type => :linexy).google_chart_type)
    
    assert_equal("bhg", GChart.new(:type => :bar, :horizontal => true, :grouped => true).google_chart_type)
    assert_equal("bhs", GChart.new(:type => :bar, :horizontal => true, :grouped => false).google_chart_type)
    assert_equal("bvs", GChart.new(:type => :bar, :horizontal => false, :grouped => false).google_chart_type)
    
    assert_equal("p", GChart.new(:type => :pie).google_chart_type)
    assert_equal("v", GChart.new(:type => :venn).google_chart_type)
    assert_equal("s", GChart.new(:type => :scatter).google_chart_type)
  end
  
  def test_google_extended_notation
    expected = {
      0 => "AA", 25 => "AZ", 26 => "Aa", 51 => "Az", 52 => "A0", 61 => "A9", 62 => "A-", 63 => "A.",
      64 => "BA", 89 => "BZ", 90 => "Ba", 115 => "Bz", 116 => "B0", 125 => "B9", 126 => "B-", 127 => "B.",
      4032 => ".A", 4057 => ".Z", 4058 => ".a", 4083 => ".z", 4084 => ".0", 4093 => ".9", 4094 => ".-", 4095 => ".."
    }
    
    expected.each do |original, encoded|
      assert_equal(encoded, GChart.encode_extended(original))
    end
    
    assert_equal("__", GChart.encode_extended(nil))    
  end
  
  def test_supports_title
    chart = GChart.new
    
    assert_nil(chart.google_query_params["chtt"])
    
    chart.title = "foo"
    assert_equal("foo", chart.google_query_params["chtt"])
    
    chart.title = "a space"
    assert_equal("a+space", chart.google_query_params["chtt"])
    
    chart.title = "a\nnewline"
    assert_equal("a|newline", chart.google_query_params["chtt"])
  end
  
  def test_generates_correct_query_params_and_url_for_simple_example
    expected = { "cht" => "lc", "chs" => "300x200", "chd" => "e:AAAo..", "chtt" => "test" }
    
    chart = GChart.new(:title => "test", :data => [1, 100, 10000])
    assert_equal(expected, chart.google_query_params)
    assert_equal("http://chart.apis.google.com/chart?chs=300x200&cht=lc&chtt=test&chd=e:AAAo..", chart.to_url)
  end
end
