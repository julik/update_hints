require "net/http"
require "open-uri"
require "timeout"
require "rexml/document"

module UpdateHints
  VERSION = '1.0.0'
  GEMCUTTER_URI = "http://rubygems.org/api/v1/gems/%s.xml"
  
  # Checks whether rubygems.org has a new version of this specific gem
  # and prints how an update can be obtained if need be.
  # Note: it swallows ANY exception to prevent network-related errors when for some
  # reason the method is run while the app is offline
  def self.version_check(gem_name, present_version_str, destination = $stderr)
    begin
      latest_version = extract_version_from_xml(open(GEMCUTTER_URI % gem_name))
      int_present, int_available = Version.new(present_version_str), Version.new(latest_version)
      if int_available > int_present
        destination << "Your version of #{gem_name} is probably out of date\n"
        destination << "(the current version is #{latest_version}, but you have #{present_version_str}).\n"
        destination << "Please consider updating (run `gem update #{gem_name}`)"
      end
    rescue Exception
    end
  end
  
  private
  
  # For stubbing
  def self.open(*any)
    super
  end
  
  #:nodoc:
  class Version
    include Comparable
    
    attr_reader :major, :minor, :tiny
    def initialize(version_str)
      @major, @minor, @tiny = version_str.split(".").map{|e| e.to_i }
    end
    
    def <=>(other)
      [:major, :minor, :tiny].each do | ver_part |
        mine, theirs = send(ver_part), other.send(ver_part)
        return mine <=> theirs unless mine == theirs
      end
      return 0
    end
  end
  
  def self.extract_version_from_xml(io)
    doc = REXML::Document.new(io)
    version_text = doc.elements["rubygem/version"].text
  end
end