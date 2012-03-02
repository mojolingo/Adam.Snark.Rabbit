require 'singleton'

class Roster
  include Singleton
  attr_reader :mutex
  
  def initialize
    @mutex = Mutex.new
    @roster = {}
  end
  
  def online?(jid)
    presence_for(jid) != :unavailable
  end
  
  def available?(jid)
    presence_for(jid) == :available
  end
  
  def presence_for(jid)
    jid = Blather::JID.new jid
    jid, resource = jid.stripped.to_s, jid.resource
    @roster[jid] ||= {}
    
    return (@roster[jid].has_key?(resource) ? @roster[jid][resource] : :unavailable) if resource

    if @roster.has_key?(jid)      
      # Take the most-avaialble state
      presence = nil
      @roster[jid].each do |r, p|
        case p
        when :available
          presence = p
        when :away
          presence = p unless presence == :available
        when :xa
          presence = p unless [:available, :away].include? presence
        when :dnd
          presence = p unless [:available, :away, :xa].include? presence
        else
          presence = p unless [:available, :away, :xa, :dnd].include? presence
        end
      end
      presence || :unavailable
    else
      :unavailable
    end
  end
  
  def update_presence_for(jid, state)
    jid = Blather::JID.new jid
    jid, resource = jid.stripped.to_s, jid.resource
    raise ArgumentError, "Must supply a resource when updating presence" unless resource
    @roster[jid] ||= {}
    @roster[jid][resource] = state
  end
  
  class << self
    def method_missing(method, *args, &block)
      instance.mutex.synchronize do
        instance.send method, *args, &block
      end
    end
  end
end
