$(document).ready ->
	
	ws = new WebSocketRails('localhost:3000/websocket')

	ws.on_open = ->
		console.log 'socket opened'

	ws.bind 'new_message', (data) =>
		console.log data
		$('#chat_log')
			.append("<div>" + data['user'] + ": " + data['text'] + "</div>")

	$('#send_message').on 'click', =>
		ws.trigger 'send_message', {text: $('#new_message').val()}
		$('#new_message').val('')

	$('#new_message').keypress (e) -> 
		$('#send_message').click() if (e.keyCode == 13 && $('#new_message').val().length > 0)	