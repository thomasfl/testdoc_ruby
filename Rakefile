require 'rubygems'
require 'hoe'

%w[rubygems rake rake/clean fileutils newgem rubigen].each { |f| require f }
require File.dirname(__FILE__) + '/lib/testdoc'

$hoe = Hoe.new('testdoc', TestDoc::VERSION) do |p|
  p.developer('Thomas Flemming', 'thomasfl@usit.uio.no')
  p.changes              = p.paragraphs_of("History.txt", 0..1).join("\n\n")
  p.rubyforge_name       = p.name
  p.summary = "Documentation generator for tests you want to give manuel testers."
  p.extra_dev_deps = [
    ['newgem', ">= #{::Newgem::VERSION}"],
    ['hoe', '>= 2.9.1']
  ]

  p.clean_globs |= %w[**/.DS_Store tmp *.log]

end

require 'newgem/tasks' # load /tasks/*.rake
Dir['tasks/**/*.rake'].each { |t| load t }

