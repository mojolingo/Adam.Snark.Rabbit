module NeuronMatchers
  class MessageMatcher
    def initialize(message, user = :default_user)
      user = default_user if user == :default_user
      @message = if message.is_a?(AdamCommon::Message)
        message
      else
        AdamCommon::Message.new body: message, user: user
      end
      @expected_confidence = 1
    end

    def matches?(neuron)
      @neuron = neuron
      matching_confidence? && matching_response?
    end

    def with_confidence(confidence)
      @expected_confidence = confidence
      self
    end

    def and_respond_with(response)
      @expected_response = response
      self
    end

    def failure_message_for_should
      "expected neuron to handle #{@message} with #{@expected_confidence*100}% confidence".tap do |message|
        message << " and reply with '#{@expected_response}'" if should_match_response?
        message << " but confidence was #{actual_confidence*100}%" unless matching_confidence?
        message << " #{matching_confidence? ? 'but' : 'and'} reply was #{actual_reply.inspect}" unless matching_response?
      end
    end

    def description
      "handle #{@message} with #{@expected_confidence*100}% confidence".tap do |description|
        description << " and reply with '#{@expected_response}'" if should_match_response?
      end
    end

    private

    def default_user
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
          "futuresimple_token" => "d2390i3290if09ik",
          "futuresimple_username" => "benlangfeld",
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
        },
        "auth_grants" => [
          {
            "_id" => "510d71c4a005b5bb45000001",
            "created_at" => "2013-02-02T20:06:28Z",
            "credentials" => {
              "token" => "f2398fj90fj9fjf",
              "expires" => false
            },
            "extra" => {
              "raw_info" => {
                "total_private_repos" => 0,
                "updated_at" => "2013-02-01T20:53:35Z",
                "type" => "User",
                "url" => "https://api.github.com/users/benlangfeld",
                "owned_private_repos" => 0,
                "organizations_url" => "https://api.github.com/users/benlangfeld/orgs",
                "collaborators" => 0,
                "gists_url" => "https://api.github.com/users/benlangfeld/gists{/gist_id}",
                "avatar_url" => "https://secure.gravatar.com/avatar/f9116c42e95b260f995680d301695a84?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png",
                "followers" => 32,
                "following" => 38,
                "created_at" => "2010-02-24T20:29:36Z",
                "html_url" => "https://github.com/benlangfeld",
                "location" => "Liverpool, UK",
                "events_url" => "https://api.github.com/users/benlangfeld/events{/privacy}",
                "repos_url" => "https://api.github.com/users/benlangfeld/repos",
                "gravatar_id" => "f9116c42e95b260f995680d301695a84",
                "disk_usage" => 102856,
                "hireable" => false,
                "received_events_url" => "https://api.github.com/users/benlangfeld/received_events",
                "followers_url" => "https://api.github.com/users/benlangfeld/followers",
                "plan" => {
                  "private_repos" => 0,
                  "collaborators" => 0,
                  "space" => 307200,
                  "name" => "free"
                },
                "public_gists" => 108,
                "public_repos" => 56,
                "name" => "Ben Langfeld",
                "blog" => "langfeld.me",
                "email" => "ben@langfeld.me",
                "subscriptions_url" => "https://api.github.com/users/benlangfeld/subscriptions",
                "starred_url" => "https://api.github.com/users/benlangfeld/starred{/owner}{/repo}",
                "following_url" => "https://api.github.com/users/benlangfeld/following",
                "company" => "Mojo Lingo LLC",
                "bio" => "My name is Ben Langfeld and I'm proud to be a generalist. I don't know everything about anything, but I do know a bit about a lot. You'll find some of it here. Enjoy.",
                "id" => 210221,
                "private_gists" => 368,
                "login" => "benlangfeld"
              }
            },
            "info" => {
              "nickname" => "benlangfeld",
              "email" => "ben@langfeld.me",
              "name" => "Ben Langfeld",
              "image" => "https://secure.gravatar.com/avatar/f9116c42e95b260f995680d301695a84?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png",
              "urls" => {
                "GitHub" => "https://github.com/benlangfeld",
                "Blog" => "langfeld.me"
              }
            },
            "provider" => "github",
            "uid" => 210221,
            "updated_at" => "2013-02-02T20:06:28Z",
            "user_id" => "510d71c4a005b5bb45000002"
          }
        ]
      }
    end

    def matching_confidence?
      actual_confidence == @expected_confidence
    end

    def actual_confidence
      @actual_confidence ||= @neuron.confidence @message
    end

    def should_match_response?
      !!@expected_response
    end

    def matching_response?
      return true unless should_match_response?
      actual_reply == @expected_response
    end

    def actual_reply
      @actual_reply ||= @neuron.reply @message
    end
  end

  def handle_message(message, user = :default_user)
    MessageMatcher.new message, user
  end
end
