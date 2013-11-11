user "adam" do
  system true
  comment "Adam User"
  home "/home/adam"
  supports :manage_home => true
end

sudo 'adam' do
  user      'adam'
  runas     'ALL'
  commands  ['/usr/sbin/restart adam']
  nopasswd  true
end
