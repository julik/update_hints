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
    flexmock(UpdateHints::Checker).new_instances.should_receive(:open).with("http://rubygems.org/api/v1/versions/tracksperanto.xml").once.and_return(xml)
    
    UpdateHints.version_check("tracksperanto", "1.2.3", output)
    assert_equal "Your version of tracksperanto is probably out of date\n(the current version is 3.2.2, but you have 1.2.3).\nPlease consider updating (run `gem update tracksperanto`)\n", output
  end
  
  def test_version_check_stays_silent_on_success
    xml = File.open(File.dirname(__FILE__) + "/sample.xml")
    output = ''
    flexmock(UpdateHints::Checker).new_instances.should_receive(:open).with("http://rubygems.org/api/v1/versions/tracksperanto.xml").once.and_return(xml)
    UpdateHints.version_check("tracksperanto", "3.2.2", output)
    assert_equal "", output
  end
  
  def test_sorts_proper_rails_gem_on_top
    xml = File.open(File.dirname(__FILE__) + "/rails_versions.xml")
    output = ''
    flexmock(UpdateHints::Checker).new_instances.should_receive(:open).with("http://rubygems.org/api/v1/versions/rails.xml").once.and_return(xml)
    # Latest version released is 2.38.1 but the latest release gem is 3.2.2. It also has 4.0.0.pre which is perfect for our test
    UpdateHints.version_check("rails", "3.1.0", output)
    assert_equal "Your version of rails is probably out of date\n(the current version is 3.2.13, but you have 3.1.0).\nPlease consider updating (run `gem update rails`)\n", output
  end
  
end
