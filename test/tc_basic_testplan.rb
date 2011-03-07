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
    t.document(ARGV)

    ## Hvordan skal vi teste dette???
    # 1. Gjøre testdoc biblioteket mer testbart
    #    - gi output til stdout med egen switch

  end

end
