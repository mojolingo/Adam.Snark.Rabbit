describe Wit do
  include WitMessages

  let(:message_body) { 'How do I?' }
  let(:intent) { 'thingy' }
  let(:entities) { {'groove' => 'tube'} }
  before do
    stub_request(:get, "https://api.wit.ai/message?q=#{message_body}")
      .to_return(body: wit_interpretation(message_body, intent, entities), headers: {'Content-Type' => 'application/json'})
  end

  it "should return a hash of data for a given query" do
    result = Wit.query message_body
    result['msg_body'].should == message_body
    result['outcome']['intent'].should == intent
    result['outcome']['entities']['groove']['value'].should == 'tube'
  end

  context "encoding issues" do
    let(:message_body) { '"Hello"' }
    before do
      stub_request(:get, "https://api.wit.ai/message?q=#{message_body}")
        .to_return(body: wit_interpretation('&quot;Hello&quot;', intent, entities), headers: {'Content-Type' => 'application/json'})
    end

    it "should properly handle strings containing quotes" do
      result = Wit.query message_body
      result['msg_body'].should == '"Hello"'
    end
  end
end
