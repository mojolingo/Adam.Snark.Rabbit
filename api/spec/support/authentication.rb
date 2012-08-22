OmniAuth.config.test_mode = true

def logged_in_with_github
  GithubMock.mock
  visit root_url
  click_link 'Login with Github'
end

module GithubMock
  class << self
    def mock
      OmniAuth.config.mock_auth[:github] = data
    end

    def data
      OmniAuth::AuthHash.new provider: "github",
        uid: 210221,
        info: info,
        extra: Hashie::Mash.new(raw_info: raw_info),
        credentials: Hashie::Mash.new(expires: false,
          token: "c64a09df7c2257be39aaf7e59ad254b1b98ccebc")
    end

    def info
      OmniAuth::AuthHash::InfoHash.new email: "ben@langfeld.me",
        name: "Ben Langfeld",
        nickname: "benlangfeld",
        urls: Hashie::Mash.new(Blog: "langfeld.me", GitHub: "https://github.com/benlangfeld")
    end

    def raw_info
      Hashie::Mash.new avatar_url: "https://secure.gravatar.com/avatar/f9116c42e95b260f995680d301695a84?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-140.png",
        bio: "My name is Ben Langfeld and I'm proud to be a generalist. I don't know everything about anything, but I do know a bit about a lot. You'll find some of it here. Enjoy.",
        blog: "langfeld.me",
        collaborators: 1,
        company: "MyStudioTools Ltd",
        created_at: "2010-02-24T20:29:36Z",
        disk_usage: 33920,
        email: "ben@langfeld.me",
        followers: 24,
        following: 39,
        gravatar_id: "f9116c42e95b260f995680d301695a84",
        hireable: true,
        html_url: "https://github.com/benlangfeld",
        id: 210221,
        location: "Preston, UK",
        login: "benlangfeld",
        name: "Ben Langfeld",
        owned_private_repos: 5,
        plan: Hashie::Mash.new(collaborators: 1, name: "micro", private_repos: 5, space: 614400),
        private_gists: 265,
        public_gists: 107,
        public_repos: 44,
        total_private_repos: 5,
        type: "User",
        url: "https://api.github.com/users/benlangfeld"
    end
  end
end

module TwitterMock
  class << self
    def mock
      OmniAuth.config.mock_auth[:twitter] = data
    end

    def data
      OmniAuth::AuthHash.new provider: "twitter",
        uid: "4508241",
        info: info,
        extra: Hashie::Mash.new(raw_info: raw_info, access_token: access_token),
        credentials: Hashie::Mash.new(secret: "g4Rc63fKPjlTpga2ZEsr9JJ8OMXKcb16q6ZRezg",
          token: "4508241-txxt3tRQfaoT65E3jh8vIH1gnglPztVn1Xex3IlOYc")
    end

    def info
      OmniAuth::AuthHash::InfoHash.new name: "Ben Langfeld",
        nickname: "benlangfeld",
        urls: Hashie::Mash.new(Twitter: "http://twitter.com/benlangfeld", Website: "http://langfeld.me"),
        description: "My name is Ben Langfeld and I'm proud to be a generalist. I don't know everything about anything, but I do know a bit about a lot. You'll find some of it here.",
        image: "http://a0.twimg.com/profile_images/2515337755/kr1ygzw7n42x7q7egits_normal.jpeg",
        location: "53.547943,-3.067047"
    end

    def access_token
      OAuth::AccessToken.new OAuth::Consumer.new('foo', 'bar'),
        :oauth_token => "4508241-txxt3tRQfaoT65E3jh8vIH1gnglPztVn1Xex3IlOYc",
        "oauth_token" => "4508241-txxt3tRQfaoT65E3jh8vIH1gnglPztVn1Xex3IlOYc",
        :oauth_token_secret => "g4Rc63fKPjlTpga2ZEsr9JJ8OMXKcb16q6ZRezg",
        "oauth_token_secret" => "g4Rc63fKPjlTpga2ZEsr9JJ8OMXKcb16q6ZRezg",
        :user_id => "4508241",
        "user_id" => "4508241",
        :screen_name => "benlangfeld",
        "screen_name" => "benlangfeld"
    end

    def raw_info
      Hashie::Mash.new contributors_enabled: false,
        created_at: "Fri Apr 13 15:05:00 +0000 2007",
        default_profile: false,
        default_profile_image: false,
        description: "My name is Ben Langfeld and I'm proud to be a generalist. I don't know everything about anything, but I do know a bit about a lot. You'll find some of it here.",
        favourites_count: 15,
        follow_request_sent: false,
        followers_count: 203,
        following: false,
        friends_count: 136,
        geo_enabled: true,
        id: 4508241,
        id_str: "4508241",
        is_translator: false,
        lang: "en",
        listed_count: 15,
        location: "53.547943,-3.067047",
        name: "Ben Langfeld",
        notifications: false,
        profile_background_color: "9AE4E8",
        profile_background_image_url: "http://a0.twimg.com/images/themes/theme1/bg.png",
        profile_background_image_url_https: "https://si0.twimg.com/images/themes/theme1/bg.png",
        profile_background_tile: false,
        profile_image_url: "http://a0.twimg.com/profile_images/2515337755/kr1ygzw7n42x7q7egits_normal.jpeg",
        profile_image_url_https: "https://si0.twimg.com/profile_images/2515337755/kr1ygzw7n42x7q7egits_normal.jpeg",
        profile_link_color: "0000FF",
        profile_sidebar_border_color: "87BC44",
        profile_sidebar_fill_color: "E0FF92",
        profile_text_color: "000000",
        profile_use_background_image: true,
        protected: false,
        screen_name: "benlangfeld",
        show_all_inline_media: false,
        status: Hashie::Mash.new(contributors: nil,
          coordinates: nil,
          created_at: "Fri Aug 17 21:16:15 +0000 2012",
          favorited: false,
          geo: nil,
          id: 236572171743412225,
          id_str: "236572171743412225",
          in_reply_to_screen_name: "josevalim",
          in_reply_to_status_id: 236557228205826048,
          in_reply_to_status_id_str: "236557228205826048",
          in_reply_to_user_id: 10230812,
          in_reply_to_user_id_str: "10230812",
          place: nil,
          retweet_count: 0,
          retweeted: false,
          source: "web",
          text: "Foo bar",
          truncated: nil
        ),
        statuses_count: 1080,
        time_zone: "London",
        url: "http://langfeld.me",
        utc_offset: 0,
        verified: false
    end
  end
end
