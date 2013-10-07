class GatherInputController < Adhearsion::CallController
  def run
    logger.debug "Listening for input"
    recording = record(start_beep: true, final_timeout: 1.seconds, format: 'wav', direction: :send).complete_event.recording

    logger.debug "Input received. Checking interpretation from AT&T..."
    listener = Celluloid::Actor[:att_speech].future.speech_to_text File.read(recording.uri.sub('file://', ''))

    play recording.uri.sub('file://', '')

    interpretation = listener.value
    logger.debug "Interpretation from AT&T: #{interpretation.inspect}"
    message = interpretation.recognition.n_best.result_text
    App.publish_message message, call.id
  end
end
