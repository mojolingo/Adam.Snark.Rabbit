# Adam Snark Rabbit

## Mojo Lingo's Go-To Rabbit

"Snark is my middle name"

Adam Snark Rabbit is your little helper. He was born at Mojo Lingo HQ and began to serve the team's every wish. He then began to evolve into a SaaS application, and here we are. He will soon be able to perform all kinds of
tasks, from announcing conference bridge participants and CI build status to triggering a deploy of applications and dropping snarky wisecracks. To begin with, his focus will be on executive/sales personnel in need of scheduling/contact assistance.

Best of all, he's yours! Find him here:

  * [The Web](http://adamrabbit.com)
  * [Jabber](xmpp:adam@adamrabbit.com)
  * [E-Mail](mailto:adam@adamrabbit.com)
  * [SIP](sip:adam@adamrabbit.com)
  * the PSTN: +1 (404) 475-4840

Or in staging:

  * [The Web](http://staging.adamrabbit.com)
  * [Jabber](xmpp:adam@staging.adamrabbit.com)
  * [E-Mail](mailto:adam@staging.adamrabbit.com)
  * [SIP](sip:adam@staging.adamrabbit.com)
  * the PSTN: +1 (678) 869-2048

Or in development:

  * [The Web](http://local.adamrabbit.com:3000)
  * [Jabber](xmpp:adam@local.adamrabbit.com)
  * [E-Mail](mailto:adam@local.adamrabbit.com)
  * [SIP](sip:adam@local.adamrabbit.com)

## Setting up a development environment

Adam has several components, which use various libraries and various package dependencies. These components are interrelated but run across several processes. The major components are:

* Memory: Web UI; Provides authentication/authorization and user administration.
  * User database, MongoDB
* User Gateways
  * Ears: Adhearsion application to present a phone interface to Adam via Rayo.
    * Rayo service: For connection with SIP & PSTN networks, and maintaining call sessions.
  * Fingers: Maintains an XMPP user presence for IM interaction.
* Brain: The AI component of the system responsible for calculating responses to messages.
* Internal/External communications systems
  * XMPP server: Adam's XMPP and Rayo clients connect here, and this system is federated with global XMPP servers for routing client requests.
  * AMQP (RabbitMQ): The asynchronous messaging system used to communicate between components for the purpose of responding to messages, among other things.

Further details are available in the `doc/` directory.

A full Vagrant development environment for Adam is included. It can be setup in the following way:

1. Install [virtualbox](https://www.virtualbox.org/wiki/Downloads)
2. Install [vagrant](http://vagrantup.com)
3. Add the [vagrant-berkshelf plugin](https://github.com/riotgames/vagrant-berkshelf) to your Vagrant installation by doing `vagrant plugin install vagrant-berkshelf`.
4. Place or symlink an SSH private key to be used to clone the app repo from Github in the VM in `deploy_key`. This will be copied to the VM. It can be a deploy key on the adam repo, or a Github user's SSH key.
5. `vagrant up` to download, launch, and provision the VMs

This is a simple Vagrant based development environment. All the usual vagrant rules apply. You will need to provide an admin password to enable NFS share setup.

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
    "twitter_secret":"changeme",
    "wit_api_key":"changeme",
    "bing_translate_key":"changeme",
    "bing_translate_secret":"changeme",
    "att_asr_key":"changeme",
    "att_asr_secret":"changeme",
    "internal_password":"changeme",
    "punchblock_port":"5224",
    "reporter":{"api_key":"changeme"}
  },
  "freeswitch": {
    "local_ip":"changeme",
    "modules": {
      "rayo": {
        "listeners": [
          {
            "type": "c2s",
            "port": "5224",
            "address": "$${rayo_ip}",
            "acl": ""
          },
          {
            "type": "c2s",
            "port": "5224",
            "address": "127.0.0.1",
            "acl": ""
          }
        ]
      }
    }
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

### Third-party integrations

Adam uses many third party services to access data or perform actions. Each of these requires authentication, and for each separate deployment, keys must be obtained. You can do this here:

* [Twitter](https://dev.twitter.com/apps)
* [Github](https://github.com/settings/applications)
* [Wit AI](http://wit.ai)
* [Bing Translate](http://go.microsoft.com/?linkid=9782667)

These credentials must then be provided to Chef in the DNA template above.

## Legal

Adam Rabbit is copyright Mojo Lingo LLC, 2013. He is not open-source and is proprietary software. Sharing of his source-code is not allowed. Some components of Adam may be extracted into open-source libraries and shared elsewhere.
