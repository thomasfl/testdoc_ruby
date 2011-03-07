# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/test_helper.rb'

class TestCaseBasicTestplanc < Test::Unit::TestCase

  def setup
    require File.dirname(__FILE__) + "/../lib/testdoc"
    require File.dirname(__FILE__) + "/../lib/testdoc_module"
  end

  def test_basic
    assert true

    t = TestDoc::TestDoc.new
    t.document(['sample_source.txt'])
    # html = IO.readlines('testplan.html','r').to_s
    # puts 'DEBUG: "'+ html + '"'
    # puts html
  end

end
