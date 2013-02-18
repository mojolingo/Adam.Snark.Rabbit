BOSH_SERVICE = "http://#{document.domain}:5280/http-bind"
ADAM_JID = "adam@#{document.domain}"
connection = null

log = (msg) ->
  $('#log').append "<div>#{msg}</div>"

onMessage = (msg) ->
  type = msg.getAttribute 'type'
  elems = msg.getElementsByTagName 'body'

  if type == "chat" && elems.length > 0
    body = elems[0]
    log Strophe.getText(body)

  # we must return true to keep the handler alive.
  # returning false would remove it after it finishes.
  return true

onConnect = (status) ->
  switch status
    when Strophe.Status.CONNECTING
      console.log 'Strophe is connecting.'

    when Strophe.Status.CONNFAIL
      console.log 'Strophe failed to connect.'

    when Strophe.Status.DISCONNECTING
      console.log 'Strophe is disconnecting.'

    when Strophe.Status.DISCONNECTED
      console.log 'Strophe is disconnected.'

    when Strophe.Status.CONNECTED
      console.log 'Strophe is connected.'
      connection.addHandler onMessage, null, 'message', null, null,  null
      sendMessage 'Hello'

sendMessage = (body) ->
  log body
  msg = $msg({to: ADAM_JID, type: 'chat'})
            .c('body').t(body)
  connection.send msg.tree()

setupConnection = (user) ->
  connection = new Strophe.Connection(BOSH_SERVICE)
  connection.connect "#{user.id}@#{document.domain}", user.authentication_token, onConnect

  $('form[name=chat]').submit ->
    message = $('#message').get(0).value
    sendMessage message
    $('#message').val ''
    return false

getCreds = ->
  $.get 'me.json', (current_user) ->
    setupConnection current_user if current_user

$(document).ready ->
  getCreds()
