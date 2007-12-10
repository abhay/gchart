= GChart

== DESCRIPTION:
  
Chart exposes the Google Chart API (http://code.google.com/apis/chart) via
a friendly Ruby interface. It can generate the URL for a given chart
(for webpage use), or download the generated PNG (for offline use).

== FEATURES/PROBLEMS:
  
* FIX (list of features or problems)

== SYNOPSIS:

  # line chart
  g = GChart.line(:data => [0, 10, 100])
  
  # bar chart
  g = GChart.bar(:data => [100, 1000, 10000])
  
  # pie chart
  g = GChart.pie(:data => [33, 33, 34])
  
  # venn diagram (asize, bsize, csize, ab, bc, ca, abc)
  g = GChart.venn(:data => [100, 80, 60, 30, 30, 30, 10])
  
  # scatter plot (list of x coords, list of y coords, optional sizes)
  g = GChart.scatter(:data => [[1, 2, 3, 4, 5], [5, 4, 3, 2, 1], [1, 2, 3, 4, 5]])
  
  # chart title
  g = GChart.line(:title => "Awesomeness over Time", :data => [0, 10, 100])
  
  g.to_url            # generate the chart's URL, or
  g.fetch             # get the PNG bytes, or
  g.write("foo.png")  # write to a file or IO object (defaults to "chart.png")

== REQUIREMENTS:

* hoe (to build)
* mocha (to build)

== INSTALL:

* sudo gem install gchart

== LICENSE:

(The MIT License)

Copyright (c) 2007 John Barnette (jbarnette@rubyforge.org)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
