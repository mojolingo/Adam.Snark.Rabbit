# Adam Memory

Memory is Adam's main datastore, primarily containing details of users of the system. Adam's Memory is accessed solely via the following HTTP API, and may be substituted for an alternative implementation which is API compatible.

Adam's Memory API should be provided via HTTP at some known domain (configurable in the rest of the system as MEMORY_URL).

## Fetching current user

In order for the chat UI on the web interface to work, it needs to fetch XMPP credentials to use for connecting to Adam's internal XMPP server.

`HTTP/1.1 GET /me.json`

The request should be authenticated via a user's existing session, and should return a representation of the current authenticated user.

The response payload is a JSON representation of the user as described in the 'User representation' section.

## Fetching a user by ID

In order to authenticate users of the internal XMPP service, the XMPP server requires a representation of the user looked up by ID, including the `authentication_token` parameter to check against the provided password.

`HTTP/1.1 GET /users/[user ID].json`

Requests should be authenticated via basic auth with a username of `adam_brain` and a shared password configured in the brain as `ADAM_MEMORY_PASSWORD`.

The response payload is a JSON representation of the user as described in the 'User representation' section.

## Searching for user by message

This API provides a mechanism for the Brain to authenticate a message for a user and tag the message with the user's data before the message is processed.

`HTTP/1.1 GET /users/find_for_message.json?message=[JSON message representation]`

The request should be authenticated via basic auth with a username of `adam_brain` and a shared password configured in the brain as `ADAM_MEMORY_PASSWORD`.

The JSON representation of a message will be in the format:

```json
{
  "source_type": "xmpp",
  "source_address": "foo@bar.com",
  "auth_address": "foo@bar.com",
  "body": "Some message",
  "user": null
}
```

The fields of a message correspond to those fields on `AdamCommon::Message` and the possible values are documented there.

The response payload is a JSON representation of the user as described in the 'User representation' section.

A user should be searched based on the set of `auth_address` and `source_type`. These parameters are provided by and validated by the gateway modules (ears, fingers, etc). For example, for message with `source_type` of `'phone'`, the `auth_address` will be a user's verified caller ID in E164 format, wheras a message of source type `'xmpp'` will have an `auth_address` which is the user's JID.

A special case is provided for a JID since an internal JID must be provisioned for the user to make use of the Web UI which connects to Adam's internal XMPP server. In this case the JID is authenticated by the XMPP server, the domain of the JID will match Adam's root domain, and the node component of the JID will match `User#id`. All JIDs at other domains are to be looked up in a user's verified collection of external JIDs used from other XMPP clients.

In case of no user being found for the provided message, a 404 should be returned.

## User representation

A user's JSON representation should conform to the following template:

```json
{
  "id":"510098ffa005b5b504000002",
  "authentication_token":null,
  "profile":{
    "name":"Ben Langfeld",
    "futuresimple_username":"benlangfeld",
    "futuresimple_token":"dfj2309j902j",
    "email_addresses":[
      {
        "address":"ben@langfeld.me",
        "confirmation_sent_at":null,
        "confirmation_token":"2a946f52-027d-4a3f-b6e1-636d387149c1",
        "confirmed_at":null
      }
    ],
    "jids":[
      {
        "address":"blangfeld@mojolingo.com",
        "confirmation_sent_at":null,
        "confirmation_token":"3180777e-c951-44f2-aaf9-4313bdbb7847",
        "confirmed_at":null
      }
    ]
  },
  "auth_grants":[
    {
      "provider":"github",
      "uid":210221,
      "updated_at":"2013-01-24T02:14:23Z",
      "created_at":"2013-01-24T02:14:23Z",
      "credentials":{
        "token":"f3j2j209f093k49",
        "expires":false
      },
      "info":{
        "nickname":"benlangfeld",
        "email":"ben@langfeld.me",
        "name":"Ben Langfeld",
        "image":"https://secure.gravatar.com/avatar/f9116c42e95b260f995680d301695a84?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png",
        "urls":{
          "GitHub":"https://github.com/benlangfeld",
          "Blog":"langfeld.me"
        }
      },
      "extra":{
        "raw_info":{
          "disk_usage":102856,
          "location":"Liverpool, UK",
          "type":"User",
          "subscriptions_url":"https://api.github.com/users/benlangfeld/subscriptions",
          "url":"https://api.github.com/users/benlangfeld",
          "owned_private_repos":0,
          "gravatar_id":"f9116c42e95b260f995680d301695a84",
          "public_repos":56,
          "html_url":"https://github.com/benlangfeld",
          "public_gists":108,
          "blog":"langfeld.me",
          "email":"ben@langfeld.me",
          "plan":{
            "space":307200,
            "private_repos":0,
            "name":"free",
            "collaborators":0
          },
          "repos_url":"https://api.github.com/users/benlangfeld/repos",
          "private_gists":367,
          "company":"Mojo Lingo LLC",
          "organizations_url":"https://api.github.com/users/benlangfeld/orgs",
          "login":"benlangfeld",
          "updated_at":"2013-01-24T02:10:03Z",
          "received_events_url":"https://api.github.com/users/benlangfeld/received_events",
          "events_url":"https://api.github.com/users/benlangfeld/events{/privacy}",
          "gists_url":"https://api.github.com/users/benlangfeld/gists{/gist_id}",
          "followers":31,
          "following":38,
          "name":"Ben Langfeld",
          "hireable":false,
          "avatar_url":"https://secure.gravatar.com/avatar/f9116c42e95b260f995680d301695a84?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png",
          "starred_url":"https://api.github.com/users/benlangfeld/starred{/owner}{/repo}",
          "followers_url":"https://api.github.com/users/benlangfeld/followers",
          "id":210221,
          "total_private_repos":0,
          "collaborators":0,
          "created_at":"2010-02-24T20:29:36Z",
          "bio":"My name is Ben Langfeld and I'm proud to be a generalist. I don't know everything about anything, but I do know a bit about a lot. You'll find some of it here. Enjoy.",
          "following_url":"https://api.github.com/users/benlangfeld/following"
        }
      }
    }
  ]
}
```
