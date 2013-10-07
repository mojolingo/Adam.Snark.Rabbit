# encoding: utf-8

$stdout.sync = true # Do not buffer stdout

Adhearsion::Events.draw do
  after_initialized do
    logger.info "Connecting to ATT speech API...."
    ATTSpeech.supervise_as :att_speech, ENV['ATT_ASR_KEY'], ENV['ATT_ASR_SECRET'], 'SPEECH'
  end
end

Adhearsion.router do
  route 'default' do
    answer
    speak "Hi, this is Adam. How can I help you?"

    loop do
      logger.debug "Listening for input"
      recording = record(start_beep: true, final_timeout: 1.seconds, format: 'wav', direction: :send).complete_event.recording

      logger.debug "Input received. Checking interpretation from AT&T..."
      listener = Celluloid::Actor[:att_speech].future.speech_to_text File.read(recording.uri.sub('file://', ''))

      play recording.uri.sub('file://', '')

      interpretation = listener.value
      logger.debug "Interpretation from AT&T: #{interpretation.inspect}"

      message = interpretation.recognition.n_best.result_text
      say "I think you said #{message}"
    end

    hangup
  end
end
