require 'spec_helper'

require_relative '../../lib/crm_neuron'

describe CRMNeuron do
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
        organisation_name: "Acme Inc",
        organisation: {
          "contact" => {
            "id"              => 26308380,
            "created_at"      => "2013-02-01T18:14:37Z",
            "updated_at"      => "2013-02-01T18:14:37Z",
            "account_id"      => 4472,
            "user_id"         => 5941,
            "name"            => "Acme Inc",
            "mobile"          => "",
            "phone"           => "",
            "email"           => "",
            "private"         => false,
            "title"           => nil,
            "skype"           => nil,
            "twitter"         => nil,
            "facebook"        => nil,
            "linkedin"        => nil,
            "address"         => nil,
            "description"     => nil,
            "is_organisation" => true,
            "contact_id"      => nil,
            "country"         => nil,
            "city"            => nil,
            "website"         => nil,
            "industry"        => nil,
            "fax"             => nil,
            "zip"             => nil,
            "region"          => nil
          }
        },
        custom_fields: {}
      }
      Pipejump::Contact.new options.merge(opts)
    end

    let(:mock_base_session) { mock 'Pipejump::Session' }
    let(:contacts) { [contact(options)] }

    before do
      mock_base_session
      Pipejump::Session.should_receive(:new).once.with(token: "d2390i3290if09ik").and_return mock_base_session
      mock_base_session.should_receive(:contacts).and_return(mock("Collection", all: contacts))
    end

    [
      [ # With a full set of details
        'Find me John Smith',
        "John Smith, CEO at Acme Inc\nPhone: +1 (515) 555-8765\nEmail: jsmith@acmeinc.com\n\nhttps://app.futuresimple.com/crm/contacts/26299451",
        {name: 'John Smith', title: 'CEO', organisation_name: 'Acme Inc', phone: '+1 (515) 555-8765', email: 'jsmith@acmeinc.com'}
      ],
      [ # When there's no position attribute
        'Find me John Smith',
        "John Smith from Acme Inc\nPhone: +1 (515) 555-8765\nEmail: jsmith@acmeinc.com\n\nhttps://app.futuresimple.com/crm/contacts/26299451",
        {name: 'John Smith', title: nil, organisation_name: 'Acme Inc', phone: '+1 (515) 555-8765', email: 'jsmith@acmeinc.com'}
      ],
      [ # With no organisation
        'Find me John Smith',
        "John Smith, CEO\nPhone: +1 (515) 555-8765\nEmail: jsmith@acmeinc.com\n\nhttps://app.futuresimple.com/crm/contacts/26299451",
        {name: 'John Smith', title: 'CEO', organisation_name: nil, phone: '+1 (515) 555-8765', email: 'jsmith@acmeinc.com'}
      ],
      [ # With no phone number
        'Find me John Smith',
        "John Smith, CEO at Acme Inc\nEmail: jsmith@acmeinc.com\n\nhttps://app.futuresimple.com/crm/contacts/26299451",
        {name: 'John Smith', title: 'CEO', organisation_name: 'Acme Inc', phone: nil, email: 'jsmith@acmeinc.com'}
      ],
      [ # With no email address
        'Find me John Smith',
        "John Smith, CEO at Acme Inc\nPhone: +1 (515) 555-8765\n\nhttps://app.futuresimple.com/crm/contacts/26299451",
        {name: 'John Smith', title: 'CEO', organisation_name: 'Acme Inc', phone: '+1 (515) 555-8765', email: nil}
      ],
      [ # With a full set of details
        'Find John Smith',
        "John Smith, CEO at Acme Inc\nPhone: +1 (515) 555-8765\nEmail: jsmith@acmeinc.com\n\nhttps://app.futuresimple.com/crm/contacts/26299451",
        {name: 'John Smith', title: 'CEO', organisation_name: 'Acme Inc', phone: '+1 (515) 555-8765', email: 'jsmith@acmeinc.com'}
      ],
      [ # With a full set of details
        'Who is John Smith?',
        "John Smith, CEO at Acme Inc\nPhone: +1 (515) 555-8765\nEmail: jsmith@acmeinc.com\n\nhttps://app.futuresimple.com/crm/contacts/26299451",
        {name: 'John Smith', title: 'CEO', organisation_name: 'Acme Inc', phone: '+1 (515) 555-8765', email: 'jsmith@acmeinc.com'}
      ],
      [ # With a full set of details
        'Who is John Smith',
        "John Smith, CEO at Acme Inc\nPhone: +1 (515) 555-8765\nEmail: jsmith@acmeinc.com\n\nhttps://app.futuresimple.com/crm/contacts/26299451",
        {name: 'John Smith', title: 'CEO', organisation_name: 'Acme Inc', phone: '+1 (515) 555-8765', email: 'jsmith@acmeinc.com'}
      ],
    ].each do |message_body, response, options = {}|
      context "for message #{message_body} with option overrides #{options.inspect}" do
        let(:options) { options }
        it { should handle_message(message_body).with_confidence(1).and_respond_with(response) }
      end
    end
  end

  context "invalid messages" do
    [nil, 'foo', 'highlight'].each do |message_body|
      it { should handle_message(message_body).with_confidence(0) }
    end
  end
end
