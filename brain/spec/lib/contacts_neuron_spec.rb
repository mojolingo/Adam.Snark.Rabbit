require 'spec_helper'

require_relative '../../lib/contacts_neuron'

describe ContactsNeuron do
  include NeuronMatchers

  context "requesting contact details" do
    def contact(opts = {})
      options = {
        session: mock_base_session,
        id: 26299451,
        created_at: "2013-02-01T17:47:43Z",
        updated_at: "2013-02-01T18:14:39Z",
        account_id: 4472,
        user_id: 5941,
        name: "John Smith",
        mobile: "",
        phone: "+1 (515) 555-8765",
        email: "jsmith@acmeinc.com",
        private: false,
        title: "CEO",
        skype: nil,
        twitter: nil,
        facebook: nil,
        linkedin: nil,
        address: "",
        description: nil,
        is_organisation: false,
        contact_id: 26308380,
        country: nil,
        city: "",
        website: nil,
        industry: nil,
        fax: nil,
        zip: "",
        region: "",
        first_name: "John",
        last_name: "Smith",
        linkedin_display: nil,
        tags_joined_by_comma: "",
        custom_fields: {}
      }
      Pipejump::Contact.new options.merge(opts)
    end

    let(:mock_base_session) { mock 'Pipejump::Session' }
    let(:options) { {} }
    let(:contacts) { [contact(options)] }

    before do
      mock_base_session
      Pipejump::Session.should_receive(:new).at_most(:once).with(token: "d2390i3290if09ik").and_return mock_base_session
      mock_base_session.should_receive(:contacts).at_most(:once).and_return(mock("Collection", all: contacts))
    end

    [
      [ # With a full set of details
        "John Smith, CEO at Acme Inc\nPhone: +1 (515) 555-8765\nEmail: jsmith@acmeinc.com\n\nhttps://app.futuresimple.com/crm/contacts/26299451",
        {name: 'John Smith', title: 'CEO', organisation_name: 'Acme Inc', phone: '+1 (515) 555-8765', email: 'jsmith@acmeinc.com'}
      ],
      [ # When there's no position attribute
        "John Smith from Acme Inc\nPhone: +1 (515) 555-8765\nEmail: jsmith@acmeinc.com\n\nhttps://app.futuresimple.com/crm/contacts/26299451",
        {name: 'John Smith', title: '', organisation_name: 'Acme Inc', phone: '+1 (515) 555-8765', email: 'jsmith@acmeinc.com'}
      ],
      [ # With no organisation
        "John Smith, CEO\nPhone: +1 (515) 555-8765\nEmail: jsmith@acmeinc.com\n\nhttps://app.futuresimple.com/crm/contacts/26299451",
        {name: 'John Smith', title: 'CEO', phone: '+1 (515) 555-8765', email: 'jsmith@acmeinc.com'}
      ],
      [ # When there's no position attribute or organisation
        "John Smith\nPhone: +1 (515) 555-8765\nEmail: jsmith@acmeinc.com\n\nhttps://app.futuresimple.com/crm/contacts/26299451",
        {name: 'John Smith', title: '', phone: '+1 (515) 555-8765', email: 'jsmith@acmeinc.com'}
      ],
      [ # With no phone number
        "John Smith, CEO at Acme Inc\nEmail: jsmith@acmeinc.com\n\nhttps://app.futuresimple.com/crm/contacts/26299451",
        {name: 'John Smith', title: 'CEO', organisation_name: 'Acme Inc', phone: '', email: 'jsmith@acmeinc.com'}
      ],
      [ # With no email address
        "John Smith, CEO at Acme Inc\nPhone: +1 (515) 555-8765\n\nhttps://app.futuresimple.com/crm/contacts/26299451",
        {name: 'John Smith', title: 'CEO', organisation_name: 'Acme Inc', phone: '+1 (515) 555-8765', email: ''}
      ],
      [ # With a full set of details
        "John Smith, CEO at Acme Inc\nPhone: +1 (515) 555-8765\nEmail: jsmith@acmeinc.com\n\nhttps://app.futuresimple.com/crm/contacts/26299451",
        {name: 'John Smith', title: 'CEO', organisation_name: 'Acme Inc', phone: '+1 (515) 555-8765', email: 'jsmith@acmeinc.com'}
      ],
      [ # With a full set of details
        "John Smith, CEO at Acme Inc\nPhone: +1 (515) 555-8765\nEmail: jsmith@acmeinc.com\n\nhttps://app.futuresimple.com/crm/contacts/26299451",
        {name: 'John Smith', title: 'CEO', organisation_name: 'Acme Inc', phone: '+1 (515) 555-8765', email: 'jsmith@acmeinc.com'}
      ],
      [ # With a full set of details
        "John Smith, CEO at Acme Inc\nPhone: +1 (515) 555-8765\nEmail: jsmith@acmeinc.com\n\nhttps://app.futuresimple.com/crm/contacts/26299451",
        {name: 'John Smith', title: 'CEO', organisation_name: 'Acme Inc', phone: '+1 (515) 555-8765', email: 'jsmith@acmeinc.com'}
      ],
    ].each do |response, options = {}|
      message_body = 'Find me John Smith'
      context "for message #{message_body} with option overrides #{options.inspect}" do
        let(:options) { options }
        let(:interpretation) { wit_interpretation message_body, 'contacts', 'contact' => 'John Smith' }
        it { should handle_message(message_body, :default_user, interpretation).and_respond_with(response) }
      end
    end

    context "when the contact doesn't exist" do
      let(:message_body) { 'Find me Joe Bloggs' }
      let(:interpretation) {  wit_interpretation message_body, 'contacts', 'contact' => 'Joe Bloggs' }

      it { should handle_message(message_body, :default_user, interpretation).and_respond_with("Sorry, I have no record of Joe Bloggs.") }
    end

    context "when the requesting user has not set futuresimple credentials" do
      let(:message_body) { "Find me Joe Bloggs" }
      let :user do
        {
          "id"  =>  "510d71c4a005b5bb45000002",
          "profile" => {
            "_id" => "510d71c5a005b5bb45000004",
            "email_addresses" => [
              {
                "_id" => "510d71c4a005b5bb45000003",
                "address" => "ben@langfeld.me",
                "confirmation_sent_at" => nil,
                "confirmation_token" => nil,
                "confirmed_at" => "2013-02-02T20:06:47+00:00"
              }
            ],
            "futuresimple_token" => nil,
            "futuresimple_username" => nil,
            "jids" => [
              {
                "_id" => "510d838ba005b521f1000001",
                "address" => "blangfeld@mojolingo.com",
                "confirmation_sent_at" => nil,
                "confirmation_token" => "a3a292cc-b41a-47ff-8db0-8603325265ce",
                "confirmed_at" => nil
              }
            ],
            "name" => "Ben Langfeld",
            "user_id" => "510d71c4a005b5bb45000002"
          }
        }
      end
      let(:interpretation) { wit_interpretation message_body, 'contacts' 'contact' => "Joe Bloggs" }

      it { should handle_message(message_body, user, interpretation).and_respond_with("Sorry, you have not configured any integrations for contact lookup.") }
    end

    context "when the requesting user cannot be identified" do
      let(:message_body) { "Find me Joe Bloggs" }
      let(:user) { nil }
      let(:interpretation) { wit_interpretation message_body, 'contacts', 'contact' => 'Joe Bloggs' }

      it { should handle_message(message_body, user).and_respond_with("Sorry, I can only help you with that if you login.") }
    end
  end
end
