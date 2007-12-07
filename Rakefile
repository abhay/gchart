require "rubygems"
require "hoe"
require "./lib/version.rb"

Hoe.new("gchart", GChart::VERSION) do |p|
  p.rubyforge_name = "gchart"
  p.author = "John Barnette"
  p.email = "jbarnette@rubyforge.org"
  p.summary = "GChart uses the Google Chart API to create pretty pictures."
  p.description = p.paragraphs_of("README.txt", 2..5).join("\n\n")
  p.url = p.paragraphs_of("README.txt", 0).first.split(/\n/)[1..-1]
  p.changes = p.paragraphs_of("History.txt", 0..1).join("\n\n")
end
