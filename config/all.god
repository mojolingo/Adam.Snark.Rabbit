God.contact(:email) do |c|
  c.name = "all"
  c.to_email = "all@mojolingo.com"
  c.group = "mojolingo"
end

# load in all god configs
God.load File.join(File.dirname(__FILE__), 'god', '*.god')

