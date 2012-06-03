# Adam Snark Rabbit

## Mojo Lingo's Go-To Rabbit

"Snark is my middle name"

Adam Snark Rabbit is your little helper. He was born at Mojo Lingo HQ and began to serve the team's every wish. He then began to evolve into a SaaS application, and here we are. He can perform all kinds of
tasks, from announcing conference bridge participants and CI build status to triggering a deploy of applications and dropping snarky wisecracks.

Best of all, he's yours! Find him here:

  * [The Web](http://adamrabbit.com)
  * [Jabber](xmpp:me@adamrabbit.com.com)
  * [E-Mail](mailto:me@adamrabbit.com)
  * [SIP](sip:hello@adamrabbit.com)
  * the PSTN: +1(404) 475-4840

## Setting up a development environment

Adam has several components, which use various libraries and various package dependencies. These components are interrelated but run across several processes. The major components are:

* User API: Provides authentication/authorization and user administration.
  * User database, MongoDB
* Web UI: Single page JavaScript application used to present a web interface to Adam, separate from but connected to the User API.
* User Gateways
  * Phone gateway: Adhearsion application to present a phone interface to Adam via Rayo.
    * Rayo service: For connection with SIP & PSTN networks, and maintaining call sessions.
  * XMPP gateway: Maintains an XMPP user presence for IM interaction.
* Internal/External communications systems
  * XMPP server: Adam's XMPP and Rayo clients connect here, and this system is federated with global XMPP servers for routing client requests.

Many of Adam's dependencies may be installed by invoking `bin/setup`.

## Production deployment

## Legal

Adam Rabbit is copyright Mojo Lingo LLC, 2012. He is not open-source and is proprietary software. Sharing of his source-code is not allowed. Some components of Adam may be extracted into open-source libraries and shared elsewhere.
