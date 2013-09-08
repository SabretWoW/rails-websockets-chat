$(document).ready ->
	
	dispatcher = new WebSocketRails('localhost:3000/websocket')

	dispatcher.on_open = ->
		console.log 'socket opened'

	dispatcher.bind 'new_message', (data) =>
		$('#chat_log')
			.append("<div>" + data['user'] + ": " + data['text'] + "</div>").fadeIn()
		$("#chat_log").animate
			scrollTop:$("#chat_log")[0].scrollHeight - $("#chat_log").height()
		console.log("#{data['user_count']}")
		$('#user_count').text(data['user_count'])

	$('#send_message').on 'click', =>
		message = $('#new_message').val()
		dispatcher.trigger 'send_message', {text: message} if message.length > 0
		$('#new_message').val('')

	$('#new_message').keypress (e) -> 
		$('#send_message').click() if (e.keyCode == 13 && $('#new_message').val().length > 0)