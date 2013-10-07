BOSH_SERVICE = "http://#{document.domain}:5280/http-bind"
connection = null

jid = (node) -> "#{node}@#{document.domain}"

format = (msg) ->
  #{msg.replace(/\n/g, "<br/>")}

onMessage = (msg) ->
  type = msg.getAttribute 'type'
  elems = msg.getElementsByTagName 'body'

  if type == "chat" && elems.length > 0
    body = elems[0]
    rabbitSpeech format(Strophe.getText(body))

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
      $('#send_message').attr('disabled', false);
      $('form[name=chat]').submit ->
        message = $('#message').get(0).value
        sendMessage message
        $('#message').val ''
        return false
      connection.addHandler onMessage, null, 'message', null, null,  null

sendMessage = (body) ->
  callerSpeech format(body)
  msg = $msg({to: jid('adam'), type: 'chat'})
            .c('body').t(body)
  connection.send msg.tree()

setupConnection = (user) ->
  return unless user
  connection = new Strophe.Connection(BOSH_SERVICE)
  connection.connect jid(user.id), user.authentication_token, onConnect

getCreds = ->
  $.get 'me.json', setupConnection

$(document).ready getCreds



### Code from Mel

# Display rabbit's message.
# Send 'null' if Adam is thinking.
rabbitSpeech = (message) ->
  unless message?
    unless adamIsThinking

      # We don't want to append an empty space.
      message = "<p class=\"typing\"></p>"
      if adamSpokeLast
        lastMessageBubble = $("#messages > .arabbit:first .bubble")
        appendTextBubble message, lastMessageBubble, "left"
      else

        # Start a new row for him.
        row message
        scrubSeparators()
      adamIsThinking = true

      # Animate the 'typing'!
      typing()
  else
    if adamIsThinking or adamSpokeLast

      # Remove his thinking indicator and replace it with his message, and kill the interval. Not in that order.
      clearInterval typingInterval
      typingInterval = false
      $(".arabbit .typing").html("").css(display: "none").addClass("not-typing").removeClass "typing"
      if adamIsThinking
        $(".arabbit .not-typing").html(message).show("slide",
          direction: "left"
        , animationTime).removeClass "not-typing"
      else
        lastMessageBubble = $("#messages > .arabbit:first .bubble")
        appendTextBubble message, lastMessageBubble, "left"
      adamIsThinking = false # Brainless bunnies behave belligerently when bombarded by big thoughts.
    else

      # Start a new row for him.
      row message
      scrubSeparators()

# Display caller's message.
callerSpeech = (message) ->
  if not adamSpokeLast or adamIsThinking

    # Find caller's latest text bubble, and pop it in there.
    lastMessageBubble = $("#messages > .caller:first .bubble")
    if typeof lastMessageBubble isnt "undefined" and lastMessageBubble.length > 0
      appendTextBubble message, lastMessageBubble, "right"
    else

      # Create a row since one didn't exist before, but put it at the bottom.
      newMessage = "<div class=\"caller\"><div class=\"row\"><div class=\"span9 offset1 message\"><div class=\"triangle\"></div><div class=\"bubble big-text\"><p style=\"display:none;\">" + message + "</p></div></div><div class=\"span2 image\"><%= image_tag('ada.jpg') %></div></div></div><div class=\"row_separator\"></div>"
      $("#messages").append newMessage + "<div class=\"separator\"></div>"
      $("#messages > .caller:first .bubble p").show "slide",
        direction: "right"
      , animationTime
  else
    row message
    scrubSeparators()
appendTextBubble = (message, lastMessageBubble, direction) ->
  $("<p style=\"display: none;\">" + message + "</p><div class=\"separator\"></div>").prependTo(lastMessageBubble).show "slide",
    direction: direction
  , animationTime

# Outputs a row for whoever didn't speak last, and switches who spoke last.
row = (message) ->
  newMessage = undefined
  newBubbleP = null
  direction = "right"
  if adamSpokeLast
    newMessage = "<div class=\"caller\"><div class=\"row\"><div class=\"span9 offset1 message\"><div class=\"triangle\"></div><div class=\"bubble big-text\"><p style=\"display:none;\">" + message + "</p></div></div><div class=\"span2 image\"><%= image_tag('ada.jpg') %></div></div></div><div class=\"row_separator\"></div>"
  else
    newMessage = "<div class=\"arabbit\"><div class=\"row\"><div class=\"span2 image\"><%= image_tag('arabbit.jpeg') %></div><div class=\"span9 message\"><div class=\"triangle\"></div><div class=\"bubble big-text\"><p style=\"display: none;\">" + message + "</p></div></div></div></div><div class=\"row_separator\"></div>"
    direction = "left"
  $("#messages").prepend newMessage + "<div class=\"separator\"></div>"
  if adamSpokeLast
    newBubbleP = $("#messages > .caller:first .bubble p")
  else
    newBubbleP = $("#messages > .arabbit:first .bubble p")
  $(newBubbleP).show "slide",
    direction: direction
  , animationTime
  adamSpokeLast = not adamSpokeLast

# Show that Adam is typing with a cute little animation.
typing = ->

  # Don't start another typing if we're already typing!
  unless typingInterval
    typingArea = $(".typing")
    dots = 0
    typingInterval = setInterval(->
      if dots < 3
        $("<span class=\"dot\">&middot;</span>").appendTo(typingArea).fadeIn()
        dots++
      else
        $(typingArea).html ""
        dots = 0
    , 600)

# Remove the text separators from previous text. Will scrub whoever didn't speak last.
# Will also make older text smaller.
scrubSeparators = ->
  unless adamSpokeLast
    $("#messages .arabbit:first .separator").css display: "none"
    $("#messages .caller .big-text").not(":eq(0)").removeClass "big-text"
  else
    $("#messages .caller:first .separator").css display: "none"
    $("#messages .arabbit .big-text").not(":eq(0)").removeClass "big-text"
  $("p:empty").not(".typing").remove()
adamSpokeLast = undefined
adamIsThinking = false
animationTime = 250
typingInterval = false
$(document).ready ->
  rabbitSpeech "How can I help?"










