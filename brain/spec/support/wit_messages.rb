module WitMessages
  def wit_interpretation(message, intent, entities = {})
    wit_entities = {}
    entities.keys.each do |key|
      wit_entities[key] = {'value' => entities[key], 'body' => entities[key]}
    end
    {
      "msg_id" => "7e7cf9a2-007d-499e-83db-49b1d0490141",
      "msg_body" => message,
      "outcome" => {
        "intent" => intent,
        "entities" => wit_entities,
        "confidence" => 0.57
      }
    }
  end
end

