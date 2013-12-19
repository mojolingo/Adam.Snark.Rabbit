# encoding: utf-8

$stdout.sync = true # Do not buffer stdout

Loquacious.env_prefix = 'ADAM_BRAIN'

Adhearsion.config do |config|
  config.platform.process_name = 'adam-brain'

  config.development do |dev|
    dev.platform.logging.level = :debug
  end

  config.punchblock.enabled = false
end

Adhearsion::Events.draw do
end
