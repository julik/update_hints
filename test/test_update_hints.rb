require "test/unit"
require "update_hints"
require 'rubygems'
require 'flexmock'
require 'flexmock/test_unit'

class TestUpdateHints < Test::Unit::TestCase
  def test_nothing_raised_on_nonexisting_gem
    assert_nothing_raised { UpdateHints.version_check(">>nonexisting<<", "123") }
  end
  
  def test_version_check_properly_output
    xml = File.open(File.dirname(__FILE__) + "/sample.xml")
    output = ''
    flexmock(UpdateHints).should_receive(:open).with("http://rubygems.org/api/v1/gems/tracksperanto.xml").once.and_return(xml)
    
    UpdateHints.version_check("tracksperanto", "1.2.3", output)
    assert_equal "Your version of tracksperanto is probably out of date\n(the current version is 2.4.1, but you have 1.2.3).\nPlease consider updating (run `gem update tracksperanto`)", output
  end
  
  def test_version_check_stays_silent_on_success
    xml = File.open(File.dirname(__FILE__) + "/sample.xml")
    output = ''
    flexmock(UpdateHints).should_receive(:open).with("http://rubygems.org/api/v1/gems/tracksperanto.xml").once.and_return(xml)
    UpdateHints.version_check("tracksperanto", "2.4.1", output)
    assert_equal "", output
  end
  
end
