$(document).ready ->
	
	ws = new WebSocketRails('localhost:3000/websocket')

	ws.on_open = ->
		console.log 'socket opened'

	ws.bind 'new_message', (data) =>
		console.log data
		$('#chat_log')
			.append("<div>" + data['user'] + ": " + data['text'] + "</div>").fadeIn()
		$("#chat_log").animate
      scrollTop:$("#chat_log")[0].scrollHeight - $("#chat_log").height()
		

	$('#send_message').on 'click', =>
		# storing the message box text in a variable since we'll probably use it later 
		message = $('#new_message').val()
		ws.trigger 'send_message', {text: message} if message.length > 0
		$('#new_message').val('')

	$('#new_message').keypress (e) -> 
		$('#send_message').click() if (e.keyCode == 13 && $('#new_message').val().length > 0)	

