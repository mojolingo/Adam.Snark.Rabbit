BOSH_SERVICE = 'http://bosh.metajack.im:5280/xmpp-httpbind'
JID = 'adamtest@jabber.org'
PASS = 'abcd1234'
ADAM_JID = 'adam@staging.adamrabbit.net'
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
  msg = $msg({to: ADAM_JID, from: JID, type: 'chat'})
            .c('body').t(body)
  connection.send msg.tree()

$(document).ready ->
  connection = new Strophe.Connection(BOSH_SERVICE)
  connection.connect JID, PASS, onConnect

  $('#send').bind 'click', ->
    message = $('#message').get(0).value
    sendMessage message
    $('#message').val ''
