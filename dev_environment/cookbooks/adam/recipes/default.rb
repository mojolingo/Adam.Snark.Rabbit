rbenv_ruby node[:adam][:ruby_version] do
  ruby_version node[:adam][:ruby_version]
  global true
end

rbenv_gem "bundler" do
  ruby_version node[:adam][:ruby_version]
end
