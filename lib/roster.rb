require 'singleton'

class Roster
  include Singleton
  attr_reader :mutex

  PRESENCE_PRIORITY = [:available, :away, :xa, :dnd, :unavailable].freeze
  
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
      # Start by assuming the jid is unavailable
      presence = :unavailable
      # Take the most-available state
      @roster[jid].each do |r, p|
        presence = p if PRESENCE_PRIORITY.index(p) < PRESENCE_PRIORITY.index(presence)
      end
      presence
    else
      :unavailable
    end
  end
  
  def update_presence_for(jid, state)
    jid = Blather::JID.new jid
    jid, resource = jid.stripped.to_s, jid.resource
    raise ArgumentError, "Must supply a resource when updating presence" unless resource
    raise ArgumentError unless PRESENCE_PRIORITY.include? state
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
