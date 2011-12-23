God::Contacts::Email.defaults do |d|
  d.from_email      = "status@mojolingo.com"
  d.from_name       = "A. Rabbit Status Monitor"
  d.delivery_method = :sendmail
end

God.contact(:email) do |c|
  c.name = "ben"
  c.to_email = "blangfeld@mojolingo.com"
  c.group = "mojolingo"
end

God.contact(:email) do |c|
  c.name = "bklang"
  c.to_email = "bklang@mojolingo.com"
  c.group = "mojolingo"
end

# load in all god configs
God.load File.join(File.dirname(__FILE__), 'god', '*.god')
