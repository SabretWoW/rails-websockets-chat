$(document).ready ->
	
	dispatcher = new WebSocketRails('localhost:3000/websocket')

	dispatcher.on_open = ->
		console.log 'socket opened'

	# TODO: break these chunks of code into separate methods
	dispatcher.bind 'new_message', (data) =>
	# any time the chat#new_message on the server gets triggered, fire the following code:

		# add the chatter + message to the chat_log <div>. not sure why the fadeIn() method doesn't fire.
		$('#chat_log')
			.append("<div>" + data['user'] + ": " + data['text'] + "</div>").fadeIn()
		# automagically scroll the chat_log down if the message would overflow.
		$("#chat_log").animate
			scrollTop:$("#chat_log")[0].scrollHeight - $("#chat_log").height()
		# update the user count in the user list header. not sure why the fadeIn() method doesn't fire.
		$('#user_count').html(data['user_count']).fadeIn(500)

		# to build the user list items
		user_list_html = ""
		for data in data['collected_users']
			user_list_html += "<li>" + data + "</li>"
		# always seem to have to call hide() before any kind of fadeIn() or other methods to help show DOM elements.
		$('#user_list').hide().html(user_list_html).fadeIn(125)


	$('#send_message').on 'click', =>
	# get the message, trigger the :send_message method on the server with the message body, and clear out the message if the field isn't empty.

		# get the value from the new_message textbox & assigns it to message
		message = $('#new_message').val()
		# trigger the :send_message on the server with the message if it's not empty
		dispatcher.trigger 'send_message', {text: message} if message.length > 0
		# clear out the new_message textbox
		$('#new_message').val('')


	$('#new_message').keypress (e) -> 
	# 'click' the send_message button if they hit enter & the message isn't empty
		$('#send_message').click() if (e.keyCode == 13 && $('#new_message').val().length > 0)