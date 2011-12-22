Adhearsion.config do |config|
  # config.platform.logging.level = :debug

  # Overwrite default punchblock credentials
  # config.punchblock.username = ""
  # config.punchblock.password = ""
end

Adhearsion.router do
  route 'default', SimonGame
end
