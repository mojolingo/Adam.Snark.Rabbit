# Adam Snark Rabbit

## Mojo Lingo's Go-To Rabbit

"Snark is my middle name"

Adam Snark Rabbit is your little helper. He was born at Mojo Lingo HQ and began to serve the team's every wish. He then began to evolve into a SaaS application, and here we are. He will soon be able to perform all kinds of
tasks, from announcing conference bridge participants and CI build status to triggering a deploy of applications and dropping snarky wisecracks. To begin with, his focus will be on executive/sales personnel in need of scheduling/contact assistance.

Best of all, he's yours! Find him here:

  * [The Web](http://adamrabbit.com)
  * [Jabber](xmpp:me@adamrabbit.com)
  * [E-Mail](mailto:me@adamrabbit.com)
  * [SIP](sip:hello@adamrabbit.com)
  * the PSTN: +1(404) 475-4840

## Setting up a development environment

Adam has several components, which use various libraries and various package dependencies. These components are interrelated but run across several processes. The major components are:

* Web UI: Provides authentication/authorization and user administration.
  * User database, MongoDB
* User Gateways
  * Phone gateway: Adhearsion application to present a phone interface to Adam via Rayo.
    * Rayo service: For connection with SIP & PSTN networks, and maintaining call sessions.
  * XMPP gateway: Maintains an XMPP user presence for IM interaction.
* Brain: The AI component of the system responsible for calculating responses to messages.
* Internal/External communications systems
  * XMPP server: Adam's XMPP and Rayo clients connect here, and this system is federated with global XMPP servers for routing client requests.
  * AMQP (RabbitMQ): The asynchronous messaging system used to communicate between components for the purpose of responding to messages, among other things.

Further details are available in the `doc/` directory.

A full Vagrant development environment for Adam is included in the dev_environment directory. Check out its README for setup instructions.

## Production deployment

1. Create a precise64 box
2. Copy `bootstrap.sh` and give it `+x` perms. Edit the placeholder username and password (CI API key).
3. Create a `dna.json` similar to the following:
```json
{
  "run_list":"role[dev]",
  "jabber_domain":"staging.adamrabbit.net",
  "adam": {
    "root_domain":"staging.adamrabbit.net",
    "deploy_key":"-----BEGIN RSA PRIVATE KEY-----ncenneccikiejwcoej-----END RSA PRIVATE KEY-----",
    "github_key":"changeme",
    "github_secret":"changeme",
    "twitter_key":"changeme",
    "twitter_secret":"changeme"
  }
}
```

4. Create `/var/chef/data_bags/ejabberd_users/adam.json` from the following template:
```json
{
  "id": "adam",
  "node": "adam",
  "domain": "staging.adamrabbit.net",
  "password": "abc123"
}
```

5. Execute `boostrap.sh`.
6. Add a cron entry to execute `bootstrap.sh` hourly.

## Legal

Adam Rabbit is copyright Mojo Lingo LLC, 2012. He is not open-source and is proprietary software. Sharing of his source-code is not allowed. Some components of Adam may be extracted into open-source libraries and shared elsewhere.
