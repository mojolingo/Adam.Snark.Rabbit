class ExtensionsController < Adhearsion::CallController
  def run
    answer
  end
  
  def conference_login(find_room = nil)
    conf = get_conference_room find_room

    validate pin if conf.pin

    conf.options ||= ''

    caller = get_variable('CALLERID(all)')
    ahn_log.conference.info("Caller #{caller} joining conference #{conf.room_number}: #{conf.name}")

    # Tell the caller how many people are in conference
    self.play('conf-thereare')
    #self.execute('KonferenceCount', conf.room_number)
    self.play('conf-peopleinconf', 'conf-placeintoconf')

    self.set_variable('CDR(accountcode)', conf.account.code + "-conf")
    #options = conf.options + "TV"
    #self.execute('Konference', conf.room_number, options)
    self.execute('ConfBridge', conf.room_number)
  end
  
  def get_conference_room(find_room = nil)
    retries = 0
    conf = nil
    while (conf.nil? && retries < 3)
      retries += 1

      if (!find_room.nil? && find_room != 's')
        ahn_log.conference.debug("Passed in conference number #{find_room}")
        # Try the passed-in room number
        digits = find_room
        find_room = nil
      else
        # Prompt user for conference number, waiting 5 seconds
        # and listening for up to 6 digits (including #)
        digits = self.input 6, :accept_key => '#', :timeout => 5,
          :play => 'conf-getconfno'
        ahn_log.conference.debug("Read digits from user: #{digits}")

        # Remove any trailing #
        digits.sub!(/\#$/, '')
      end

      conf = Conferences.find(:first, :conditions => {:room_number => digits})

      unless conf
        self.play('conf-invalid')
      end
    end

    unless conf
      # Retries must have been exceeded.  No conference info available
      self.play('goodbye')
      self.hangup
      return false
    end
  end
  
  def validate_pin
    pin = conf.pin.to_s
    ahn_log.conference.debug("Getting PIN from caller for #{conf.room_number}")
    digits = nil
    retries = 0
    while (retries < 3 && pin != digits)
      retries += 1
      digits = self.input 6, :accept_key => '#', :timeout => 5,
        :play => 'conf-getpin'
      ahn_log.conference.debug("Read PIN: #{digits}")

      if (pin != digits)
        self.play('conf-invalidpin')
      end
    end

    if (pin != digits)
      ahn_log.conference.info("Conference PIN authentication failed for #{conf.room_number}.")
      self.play('goodbye')
      self.hangup
      return false
    end
  end
end
