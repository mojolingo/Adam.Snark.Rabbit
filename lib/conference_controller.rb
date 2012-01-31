class ExtensionsController < Adhearsion::CallController
  def run
    answer
  end
  
  def conference_login(find_room = nil)
    conf = get_conference_room find_room

    validate_pin(conf) if conf.pin

    conf.options ||= ''

    caller = get_variable('CALLERID(all)')
    logger.info("Caller #{caller} joining conference #{conf.room_number}: #{conf.name}")

    # Tell the caller how many people are in conference
    play('conf-thereare')
    #execute('KonferenceCount', conf.room_number)
    play('conf-peopleinconf', 'conf-placeintoconf')

    set_variable('CDR(accountcode)', conf.account.code + "-conf")
    #options = conf.options + "TV"
    #execute('Konference', conf.room_number, options)
    execute('ConfBridge', conf.room_number)
  end
  
  def get_conference_room(find_room = nil)
    retries = 0
    conf = nil
    while (conf.nil? && retries < 3)
      retries += 1

      unless find_room
        logger.debug("Passed in conference number #{find_room}")
        # Try the passed-in room number
        digits = find_room
        find_room = nil
      else
        # Prompt user for conference number, waiting 5 seconds
        # and listening for up to 6 digits (including #)
        digits = input 6, :accept_key => '#', :timeout => 5, :play => 'conf-getconfno'
        logger.debug("Read digits from user: #{digits}")

        # Remove any trailing #
        digits.sub!(/\#$/, '')
      end

      conf = Conferences.find(:first, :conditions => {:room_number => digits})

      play('conf-invalid') unless conf
    end

    unless conf
      # Retries must have been exceeded.  No conference info available
      play('goodbye')
      hangup
    end
  end
  
  def validate_pin(conf)
    pin = conf.pin.to_s
    logger.debug("Getting PIN from caller for #{conf.room_number}")
    digits = nil
    retries = 0
    while retries < 3 && pin != digits
      retries += 1
      digits = input 6, :accept_key => '#', :timeout => 5,
        :play => 'conf-getpin'
      logger.debug "Read PIN: #{digits}"

      unless pin == digits
        play 'conf-invalidpin'
      end
    end

    unless pin == digits
      logger.info "Conference PIN authentication failed for #{conf.room_number}."
      play 'goodbye'
      hangup
    end
  end
end
