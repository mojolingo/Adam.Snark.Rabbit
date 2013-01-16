# require 'isaac/bot'
# require 'time'

# class IrcBot < Adhearsion::Plugin
#   attr_accessor :bot

#   def initialize
#     logger.info "Adhearsion IRC Bot initializing"
#     @channels = {}
#     @config = Adhearsion.config[:ircbot]

#     @bot = Isaac::Bot.new do
#       configure do |c|
#         c.nick   = @config.nick
#         c.server = @config.server
#         c.port   = @config.port
#         c.ssl    = @config.ssl
#       end
#     end
#   end

#   def run
#     Thread.new { catching_standard_errors { @bot.start } }
#   end

# #    # FIXME: Convert to Punchblock events
# #    Events.register_callback([:asterisk, :manager_interface]) do |event|
# #      case event.name.downcase
# #      when "conferencestate"
# #        if event.headers["State"].downcase == "speaking"
# #          say_speaker event.headers["ConferenceName"], event.headers["Channel"]
# #        end
# #      when "conferencejoin"
# #        announce event.headers["CallerIDName"], "joining", event.headers["ConferenceName"]
# #      when "conferenceleave"
# #        announce event.headers["CallerIDName"], "leaving", event.headers["ConferenceName"]
# #      end
# #
# #    end

#   def announce(name, action, room)
#     COMPONENTS.ircbot['rooms'][room].each do |channel|
#       @bot.msg channel, "#{name} #{action} conference room #{room}"
#     end if !COMPONENTS.ircbot['rooms'].nil? && COMPONENTS.ircbot['rooms'].has_key?(room)
#   end

#   def say_speaker(room, channel)
#     catching_standard_errors do
#       @channels[channel] = Time.at(0) if !@channels.has_key?(channel)

#       if @channels[channel] < (Time.now - COMPONENTS.ircbot['announcedelay'])
#         name = manager_interface.send_action("GetVar", { 'Channel' => channel, 'Variable' => "CALLERID(name)" }).headers["Value"]

#         COMPONENTS.ircbot['rooms'][room].each do |channel|
#           @bot.msg channel, "[#{room}] Speaking: #{name}"
#         end if !COMPONENTS.ircbot['rooms'].nil? && COMPONENTS.ircbot['rooms'].has_key?(room)
#       end
#     end
#   end
# end