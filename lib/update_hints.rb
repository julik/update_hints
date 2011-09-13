require "net/http"
require "open-uri"
require "timeout"
require "rexml/document"
require "rubygems"

module UpdateHints
  VERSION = '1.0.1'
  GEMCUTTER_URI = "http://rubygems.org/api/v1/gems/%s.xml"
  
  # Checks whether rubygems.org has a new version of this specific gem
  # and prints how an update can be obtained if need be.
  # Note: it swallows ANY exception to prevent network-related errors when for some
  # reason the method is run while the app is offline
  def self.version_check(gem_name, present_version_str, destination = $stderr)
    begin
      version_check_without_exception_suppression(gem_name, present_version_str, destination)
    rescue Exception
    end
  end
  
  private
  
  def self.version_check_without_exception_suppression(gem_name, present_version_str, destination)
    latest_version = extract_version_from_xml(open(GEMCUTTER_URI % gem_name))
    # Gem::Version was known to throw when a frozen string is passed to the constructor, see
    # https://github.com/rubygems/rubygems/commit/48f1d869510dcd325d6566df7d0147a086905380
    int_present, int_available = Gem::Version.new(present_version_str.dup), Gem::Version.new(latest_version.dup)
    if int_available > int_present
      destination << "Your version of #{gem_name} is probably out of date\n"
      destination << "(the current version is #{latest_version}, but you have #{present_version_str}).\n"
      destination << "Please consider updating (run `gem update #{gem_name}`)\n"
    end
  end
  
  # For stubbing
  def self.open(*any)
    super
  end
  
  def self.extract_version_from_xml(io)
    doc = REXML::Document.new(io)
    version_text = doc.elements["rubygem/version"].text
  end
end