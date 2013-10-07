require 'date'
require 'blurrily/map'

class AstriconPresentations
  SESSIONS = {
    "Asterisk: Views from the Community" => { speakers: ["Phillippe Lindheimer", "Olle E. Johansson", "Alistair Cunningham", "Mark Spencer"], start: DateTime.parse('2013-10-09 9:00 EDT'), end: DateTime.parse('2013-10-09 9:45 EDT'), room: 'Grand Ballroom III & IV', track: 'Keynote' },
    "Intro to VoIP Security – They know who you are and how to find you" => { speakers: ['Eric Klein'], start: DateTime.parse('2013-10-09 10:00 EDT'), end: DateTime.parse('2013-10-09 10:35 EDT'), room: 'Chambers', track: 'Security Master Class'},
    "Hardening Your System" => { speakers: ['Eric Klein'], start: DateTime.parse('2013-10-09 11:00 EDT'), end: DateTime.parse('2013-10-09 11:35 EDT'), room: 'Chambers', track: 'Security Master Class'},
    "Compromised a hacking tutorial and lab" => { speakers: ['Phillip Mullis'], start: DateTime.parse('2013-10-09 11:40 EDT'), end: DateTime.parse('2013-10-09 12:15 EDT'), room: 'Chambers', track: 'Security Master Class'},
    "PBX Hacking 101" => { speakers: ['Phillip Mullis'], start: DateTime.parse('2013-10-09 13:45 EDT'), end: DateTime.parse('2013-10-09 14:20 EDT'), room: 'Chambers', track: 'Security Master Class'},
    "Automated Hacker Mitigation Using Fail2ban and Cisco Access List" => { speakers: ['J. R. Richardson'], start: DateTime.parse('2013-10-09 14:25 EDT'), end: DateTime.parse('2013-10-09 15:00 EDT'), room: 'Chambers', track: 'Security Master Class'},
    "VoIP Security Panel" => { speakers: ['Eric Klein', 'Phillip Mullis', 'J. R. Richardson', 'Nir Simionovich', 'Flavio E. Goncalves'], start: DateTime.parse('2013-10-09 15:30 EDT'), end: DateTime.parse('2013-10-09 16:05 EDT'), room: 'Chambers', track: 'Security Master Class'},
    "Best practice for SMB IP telephony in Asia" => { speakers: ['Kwangsik Kim'], start: DateTime.parse('2013-10-09 10:00 EDT'), end: DateTime.parse('2013-10-09 10:35 EDT'), room: 'Grand Ballroom II', track: 'Business  Case Studies'},
    "Increasing Security for Journalists and Human Rights Defenders in Mexico through a Creative Multi-Technology Approach" => { speakers: ['Juan Carlos Fernandez'], start: DateTime.parse('2013-10-09 11:00 EDT'), end: DateTime.parse('2013-10-09 11:35 EDT'), room: 'Grand Ballroom II', track: 'Business  Case Studies'},
    "Using Social Media to Build Your Business" => { speakers: ['Susan Elder'], start: DateTime.parse('2013-10-09 11:40 EDT'), end: DateTime.parse('2013-10-09 12:15 EDT'), room: 'Grand Ballroom II', track: 'Business  Case Studies'},
    "When to sell hosted vs. CPE Asterisk" => { speakers: ['Aryn Nakaoka'], start: DateTime.parse('2013-10-09 13:45 EDT'), end: DateTime.parse('2013-10-09 14:20 EDT'), room: 'Grand Ballroom II', track: 'Business  Case Studies'},
    "Asterisk-based Distro Panel" => { speakers: ['Panel'], start: DateTime.parse('2013-10-09 14:25 EDT'), end: DateTime.parse('2013-10-09 15:00 EDT'), room: 'Grand Ballroom II', track: 'Business  Case Studies'},
    "DR & BC – the Asterisk Advantage" => { speakers: ['Dennis Little'], start: DateTime.parse('2013-10-09 15:30 EDT'), end: DateTime.parse('2013-10-09 16:05 EDT'), room: 'Grand Ballroom II', track: 'Business  Case Studies'},
    "Asterisk, a key building block for great solutions" => { speakers: ['James Body'], start: DateTime.parse('2013-10-09 10:00 EDT'), end: DateTime.parse('2013-10-09 10:35 EDT'), room: 'Kennesaw', track: 'WebRTC/Cloud'},
    "WebRTC? What's the use?" => { speakers: ['Jakub Klausa'], start: DateTime.parse('2013-10-09 11:00 EDT'), end: DateTime.parse('2013-10-09 11:35 EDT'), room: 'Kennesaw', track: 'WebRTC/Cloud'},
    "A deep dive into WebRTC Media" => { speakers: ['Tim Panton'], start: DateTime.parse('2013-10-09 11:40 EDT'), end: DateTime.parse('2013-10-09 12:15 EDT'), room: 'Kennesaw', track: 'WebRTC/Cloud'},
    "The new SIP stack in Asterisk" => { speakers: ['Joshua Colp', 'Mark Michelson'], start: DateTime.parse('2013-10-09 13:45 EDT'), end: DateTime.parse('2013-10-09 14:20 EDT'), room: 'Kennesaw', track: 'WebRTC/Cloud'},
    "Using PHP/mySQL to Extend Asterisk" => { speakers: ['David Martin'], start: DateTime.parse('2013-10-09 14:25 EDT'), end: DateTime.parse('2013-10-09 15:00 EDT'), room: 'Kennesaw', track: 'WebRTC/Cloud'},
    "Bringing Real-time VoIP Metrics to 2013" => { speakers: ['Dan Jenkins'], start: DateTime.parse('2013-10-09 15:30 EDT'), end: DateTime.parse('2013-10-09 16:05 EDT'), room: 'Kennesaw', track: 'WebRTC/Cloud'},
    "The experiment is over – time to get serious about realtime communication!" => { speakers: ['Olle E. Johansson'], start: DateTime.parse('2013-10-09 10:00 EDT'), end: DateTime.parse('2013-10-09 10:35 EDT'), room: 'Grand Ballroom I', track: 'Tutorials/Development'},
    "Asterisk for Web Devs" => { speakers: ['David M. Lee', 'Jared Smith'], start: DateTime.parse('2013-10-09 11:00 EDT'), end: DateTime.parse('2013-10-09 11:35 EDT'), room: 'Grand Ballroom I', track: 'Tutorials/Development'},
    "T1/E1 fundamentals" => { speakers: ['Russ Meyerreicks'], start: DateTime.parse('2013-10-09 11:40 EDT'), end: DateTime.parse('2013-10-09 12:15 EDT'), room: 'Grand Ballroom I', track: 'Tutorials/Development'},
    "Spice Up your Asterisk Server with Kamailio" => { speakers: ['Klaus Darilion'], start: DateTime.parse('2013-10-09 13:45 EDT'), end: DateTime.parse('2013-10-09 14:20 EDT'), room: 'Grand Ballroom I', track: 'Tutorials/Development'},
    "SIP over WebSockets and load-balancing on Kamailio" => { speakers: ['Peter Dunkley'], start: DateTime.parse('2013-10-09 14:25 EDT'), end: DateTime.parse('2013-10-09 15:00 EDT'), room: 'Grand Ballroom I', track: 'Tutorials/Development'},
    "Kamailio: The story for Asterisk" => { speakers: ['Daniel-Constantin Mierla'], start: DateTime.parse('2013-10-09 15:30 EDT'), end: DateTime.parse('2013-10-09 16:05 EDT'), room: 'Grand Ballroom I', track: 'Tutorials/Development'},
    "WebRTC: How it will shape the communications industry, and implications for the Asterisk community" => { speakers: ['Phil Edelholm'], start: DateTime.parse('2013-10-10 9:45 EDT'), end: DateTime.parse('2013-10-10 9:45 EDT'), room: 'Grand Ballroom III & IV', track: 'Keynote' },
    "How to detect and prevent frauds on Asterisk Servers" => { speakers: ['Flavio E. Goncalves'], start: DateTime.parse('2013-10-10 10:00 EDT'), end: DateTime.parse('2013-10-10 10:35 EDT'), room: 'Chambers', track: 'Security Master Class'},
    "CSI: VoIP – Analyzing a VoIP fraud case, hands on case" => { speakers: ['Nir Simionovich'], start: DateTime.parse('2013-10-10 11:00 EDT'), end: DateTime.parse('2013-10-10 11:35 EDT'), room: 'Chambers', track: 'Security Master Class'},
    "CSI: VoIP – Analyzing a Hack Attempt" => { speakers: ['Nir Simionovich'], start: DateTime.parse('2013-10-10 11:40 EDT'), end: DateTime.parse('2013-10-10 12:15 EDT'), room: 'Chambers', track: 'Security Master Class'},
    "Automated Hacker Mitigation Live Demonstration Hands-On Lab" => { speakers: ['J. R. Richardson'], start: DateTime.parse('2013-10-10 13:45 EDT'), end: DateTime.parse('2013-10-10 14:20 EDT'), room: 'Chambers', track: 'Security Master Class'},
    "Overcoming Security Challenges of IP Communications by Using SIP Endpoints" => { speakers: ['Wei Tang'], start: DateTime.parse('2013-10-10 14:25 EDT'), end: DateTime.parse('2013-10-10 15:00 EDT'), room: 'Chambers', track: 'Security Master Class'},
    "VoIP Security Panel" => { speakers: ['Eric Klein', 'Phillip Mullis', 'J. R. Richardson', 'Nir Simionovich', 'Flavio E. Goncalves', 'Wei Tang'], start: DateTime.parse('2013-10-10 15:30 EDT'), end: DateTime.parse('2013-10-10 16:00 EDT'), room: 'Chambers', track: 'Security Master Class'},
    "Key Aspects of the Largest Asterisk-based Retail Roll-out in the United States" => { speakers: ['Steven Porter'], start: DateTime.parse('2013-10-10 10:00 EDT'), end: DateTime.parse('2013-10-10 10:35 EDT'), room: 'Grand Ballroom II', track: 'Business  Case Studies'},
    "Taking over the world on a budget" => { speakers: ['Cassius Smith'], start: DateTime.parse('2013-10-10 11:00 EDT'), end: DateTime.parse('2013-10-10 11:35 EDT'), room: 'Grand Ballroom II', track: 'Business  Case Studies'},
    "Building a hosted, multi-tenant contact center environment fro thousands of agents" => { speakers: ['Matt Florell'], start: DateTime.parse('2013-10-10 11:40 EDT'), end: DateTime.parse('2013-10-10 12:15 EDT'), room: 'Grand Ballroom II', track: 'Business  Case Studies'},
    "World Domination" => { speakers: ['Jon "Maddog" Hall'], start: DateTime.parse('2013-10-10 13:45 EDT'), end: DateTime.parse('2013-10-10 14:20 EDT'), room: 'Grand Ballroom II', track: 'Business  Case Studies'},
    "Stop The Presses! Asterisk at Berkshire Hathaway Media (Part 1)" => { speakers: ['Corey McFadden'], start: DateTime.parse('2013-10-10 14:20 EDT'), end: DateTime.parse('2013-10-10 15:00 EDT'), room: 'Grand Ballroom II', track: 'Business  Case Studies'},
    "Stop The Presses! Asterisk at Berkshire Hathaway Media (Part 2)" => { speakers: ['Martin Conroy'], start: DateTime.parse('2013-10-10 15:30 EDT'), end: DateTime.parse('2013-10-10 16:00 EDT'), room: 'Grand Ballroom II', track: 'Business  Case Studies'},
    "AGI/AMI to ARI" => { speakers: ['Matt Riddell'], start: DateTime.parse('2013-10-10 10:00 EDT'), end: DateTime.parse('2013-10-10 10:35 EDT'), room: 'Kennesaw', track: 'WebRTC/Cloud'},
    "Implementation Lessons using WebRTC in Asterisk" => { speakers: ['Moises Silva'], start: DateTime.parse('2013-10-10 11:00 EDT'), end: DateTime.parse('2013-10-10 11:35 EDT'), room: 'Kennesaw', track: 'WebRTC/Cloud'},
    "Asterisk 12 Overview" => { speakers: ['Matt Jordan'], start: DateTime.parse('2013-10-10 11:40 EDT'), end: DateTime.parse('2013-10-10 12:15 EDT'), room: 'Kennesaw', track: 'WebRTC/Cloud'},
    "Stylin'n'Profilin your Asterisk install" => { speakers: ['Shaun Ruffell'], start: DateTime.parse('2013-10-10 13:45 EDT'), end: DateTime.parse('2013-10-10 14:20 EDT'), room: 'Kennesaw', track: 'WebRTC/Cloud'},
    "What's Next: How to charge more by reinventing cloud PBX services" => { speakers: ['Ben Klang'], start: DateTime.parse('2013-10-10 14:25 EDT'), end: DateTime.parse('2013-10-10 15:00 EDT'), room: 'Kennesaw', track: 'WebRTC/Cloud'},
    "APIs beyond Asterisk 12" => { speakers: ['Max Schroeder'], start: DateTime.parse('2013-10-10 15:30 EDT'), end: DateTime.parse('2013-10-10 16:00 EDT'), room: 'Kennesaw', track: 'WebRTC/Cloud'},
    "Distributing call queues for Asterisk using Python and Redis" => { speakers: ['Paul Belanger'], start: DateTime.parse('2013-10-10 10:00 EDT'), end: DateTime.parse('2013-10-10 10:35 EDT'), room: 'Grand Ballroom I', track: 'Tutorials/Development'},
    "Getting creative with Asterisk" => { speakers: ['Warren Selby'], start: DateTime.parse('2013-10-10 11:00 EDT'), end: DateTime.parse('2013-10-10 11:35 EDT'), room: 'Grand Ballroom I', track: 'Tutorials/Development'},
    "Asterisk and Databases" => { speakers: ['Francesco Prior'], start: DateTime.parse('2013-10-10 11:40 EDT'), end: DateTime.parse('2013-10-10 12:15 EDT'), room: 'Grand Ballroom I', track: 'Tutorials/Development'},
    "Apps on the phone" => { speakers: ['Tom De Moore'], start: DateTime.parse('2013-10-10 13:45 EDT'), end: DateTime.parse('2013-10-10 14:20 EDT'), room: 'Grand Ballroom I', track: 'Tutorials/Development'},
    "Developing a state-of-the-art, audio-related Asterisk Application Module" => { speakers: ['Thomas Arimont'], start: DateTime.parse('2013-10-10 14:25 EDT'), end: DateTime.parse('2013-10-10 15:00 EDT'), room: 'Grand Ballroom I', track: 'Tutorials/Development'},
    "Discover Session Description Protocol" => { speakers: ['Clod Patry'], start: DateTime.parse('2013-10-10 15:30 EDT'), end: DateTime.parse('2013-10-10 16:00 EDT'), room: 'Grand Ballroom I', track: 'Tutorials/Development'},
    "AstriCon Recap and Asterisk Project Updates" => { speakers: ['Panel'], start: DateTime.parse('2013-10-10 16:00 EDT'), end: DateTime.parse('2013-10-10 17:00 EDT'), room: 'Grand Ballroom III & IV', track: 'Keynote' }
  }

  SESSION_KEYS = SESSIONS.keys
    
  SPEAKERS = [
    'Alistair Cunningham',
    'Aryn Nakaoka',
    'Ben Klang',
    'Cassius Smith',
    'Clod Patry',
    'Corey McFadden',
    'Dan Jenkins',
    'Daniel-Constantin Mierla',
    'David M. Lee',
    'David Martin',
    'Dennis Little',
    'Eric Klein',
    'Flavio E. Goncalves',
    'Francesco Prior',
    'J. R. Richardson',
    'Jakub Klausa',
    'James Body',
    'Jared Smith',
    'Jon “Maddog” Hall',
    'Joshua Colp',
    'Juan Carlos Fernandez',
    'Klaus Darilion',
    'Kwangsik Kim',
    'Mark Michelson',
    'Mark Spencer',
    'Martin Conroy',
    'Matt Florell',
    'Matt Jordan',
    'Matt Riddell',
    'Max Schroeder',
    'Moises Silva',
    'Nir Simionovich',
    'Olle E. Johansson',
    'Panel',
    'Paul Belanger',
    'Peter Dunkley',
    'Phil Edelholm',
    'Phillip Mullis',
    'Phillippe Lindheimer',
    'Russ Meyerreicks',
    'Shaun Ruffell',
    'Steven Porter',
    'Susan Elder',
    'Thomas Arimont',
    'Tim Panton',
    'Tom De Moor',
    'Warren Selby',
    'Wei Tang'
  ]

  ROOMS = [
    'Grand Ballroom 1',
    'Grand Ballroom 2',
    'Grand Ballroom 3 & 4',
    'Chambers',
    'Kennesaw'
  ]

  TRACKS = [
    'Keynote',
    'Security Master Class',
    'WebRTC/Cloud',
    'Tutorials/Development',
    'Business & Case Studies'
  ]

  def initialize
    @session_map = Blurrily::Map.new
    SESSION_KEYS.each_index { |index| @session_map.put SESSION_KEYS[index], index }

    @speaker_map = Blurrily::Map.new
    SPEAKERS.each_index {|index| @speaker_map.put SPEAKERS[index], index }

    @room_map = Blurrily::Map.new
    ROOMS.each_index {|index| @room_map.put ROOMS[index], index }
    
    @track_map = Blurrily::Map.new
    TRACKS.each_index {|index| @track_map.put TRACKS[index], index }
  end

  def intent
    'astricon_presentations'
  end

  def response(message, interpretation)
    entities = interpretation['outcome']['entities']

  end

end
