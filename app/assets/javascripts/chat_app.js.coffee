$(document).ready ->
	
	dispatcher = new WebSocketRails('localhost:3000/websocket')

	dispatcher.on_open = ->
		console.log 'socket opened'

	# TODO: break these chunks of code into separate methods
	dispatcher.bind 'new_message', (data) =>
		$('#chat_log')
			.append("<div>" + data['user'] + ": " + data['text'] + "</div>").fadeIn()
		$("#chat_log").animate
			scrollTop:$("#chat_log")[0].scrollHeight - $("#chat_log").height()
		$('#user_count').html(data['user_count']).fadeIn(1000)

		user_list_html = ""
		for data in data['collected_users']
			user_list_html += "<li>" + data + "</li>"
		$('#user_list').hide().html(user_list_html).fadeIn(125)


	$('#send_message').on 'click', =>
		message = $('#new_message').val()
		dispatcher.trigger 'send_message', {text: message} if message.length > 0
		$('#new_message').val('')


	$('#new_message').keypress (e) -> 
		$('#send_message').click() if (e.keyCode == 13 && $('#new_message').val().length > 0)