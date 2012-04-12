require 'spec_helper'

class MockExtension
  attr_accessor :dn, :ast_voicemail_mailbox, :ast_context, :ast_user_channel, :telephone_number
end

describe ExtensionController do
  let :mockexten do
    m = MockExtension.new
    m.dn = "uid=x,ou=Extensions,dc=base,dc=com"
    m.ast_voicemail_mailbox = "101"
    m.ast_context = "testing"
    m.ast_user_channel = "SIP/1234"
    m.telephone_number = "4044754840"
    m
  end


  it 'should default the account to "mojolingo"' do
    pending
    extension = 101
    account = "testing"
    Extension.expects(:find).with(:filter => "(&(AstVoicemailMailbox=#{extension})(AstContext=#{account}))").returns mockexten
  end
end
