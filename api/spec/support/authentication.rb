OmniAuth.config.test_mode = true

module GithubMock
  class << self
    def mock
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new credentials: Hashie::Mash.new(expires: false, token: "c64a09df7c2257be39aaf7e59ad254b1b98ccebc"),
        extra: Hashie::Mash.new(raw_info: raw_info, info: info),
        provider: "github",
        uid: 10221
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

    def info
      OmniAuth::AuthHash::InfoHash.new email: "ben@langfeld.me",
        name: "Ben Langfeld",
        nickname: "benlangfeld",
        urls: Hashie::Mash.new(Blog: "langfeld.me", GitHub: "https://github.com/benlangfeld")
    end
  end
end
