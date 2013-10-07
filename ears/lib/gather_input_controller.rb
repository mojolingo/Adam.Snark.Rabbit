class GatherInputController < Adhearsion::CallController
  def run
    logger.debug "Listening for input"
    recording = record(start_beep: true, initial_timeout: 4.seconds, final_timeout: 1.seconds, format: 'wav', direction: :send).complete_event.recording

    logger.debug "Input received. Checking interpretation from AT&T..."
    listener = Celluloid::Actor[:att_speech].future.speech_to_text File.read(recording.uri.sub('file://', ''))

    play recording.uri.sub('file://', '')

    interpretation = listener.value
    logger.debug "Interpretation from AT&T: #{interpretation.inspect}"
    if interpretation.recognition.status == 'OK' && interpretation.recognition.n_best.confidence >= 0.4
      message = interpretation.recognition.n_best.result_text
      App.publish_message message, call.id
    else
      say "Sorry, I didn't catch that."
      pass self.class
    end
  end
end
