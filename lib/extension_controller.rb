class ExtensionController < Adhearsion::CallController
  def run
    answer

    match = @call.variables[:to].match /^<sip:(\d+)@/
    get_destinations match[0]
  end

  def get_destinations(extension, account = 'mojolingo')
    logger.info "Looking up destinations for #{extension}@#{account}"
    numbers = []
    devices = []
    count = 0
    # The following results in an array of entries, or |entry| inside the block.
    # Each |entry| is an array of [dn, attributes] where attributes is the
    # typical hash you would expect from LDAP.  Each attribute is an array of
    # one or more values.
    Extension.search :filter => "(&(AstVoicemailMailbox=#{extension})(AstContext=#{account}))" do |entry|
      numbers = Array(entry.second["telephoneNumber"])
      devices = Array(entry.second["AstUserChannel"])
      count += 1
    end

    case count
    when 0
      # Zero entries found.  This extension does not exist.
      logger.debug "No entry found for #{extension}@{account}"
      nil
    when 1
      logger.debug "Found destinations for #{extension}@#{account}: numbers: #{numbers.join(', ')}; devices: #{devices.join(', ')}"
      {:numbers => numbers, :devices => devices}
    else
      logger.warn "Too many entries (#{count}) match #{extension}@{account}"
      nil
    end
  end
end
