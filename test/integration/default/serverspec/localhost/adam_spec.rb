require 'spec_helper'

describe 'Adam Snark Rabbit' do
  describe command("sudo -u adam -i sh -c 'cd /srv/adam/current && rake'") do
    it { should return_exit_status 0 }
  end
end
