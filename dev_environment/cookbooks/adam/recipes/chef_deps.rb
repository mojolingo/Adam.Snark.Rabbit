g = chef_gem 'treetop' do
  action :nothing
end

g.run_action :install

Gem.clear_paths
