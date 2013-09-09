class ChatController < WebsocketRails::BaseController

  # TODO: before_filters to fetch an array of usernames & the user count


	def client_connected
    connection_store[:username] = "Chatter #{Random.rand(900) + 100}"
    collected_users = connection_store.collect_all(:username).sort!
    user_count = collected_users.count

    broadcast_message :new_message, { user: "System", 
                                      text: "New user #{connection_store[:username]} connected!  (Users: #{user_count})", 
                                      user_count: user_count, 
                                      collected_users: collected_users }
  end

	def send_message
		username = connection_store[:username]
    collected_users = connection_store.collect_all(:username).sort!
    user_count = collected_users.count
    message.merge!(username: username, 
                   user_count: user_count, 
                   collected_users: collected_users)

		broadcast_message :new_message, { user: username, 
                                      text: message[:text], 
                                      user_count: message[:user_count], 
                                      collected_users: collected_users }

	end

  # TODO: implement name change feature
	# def set_name
	# 	connection_store[:username] = message[:name]
	# end

  def client_disconnected
    collected_users ||= connection_store.collect_all(:username).sort!
    user_count ||= collected_users.count

    broadcast_message :new_message, { user: "System", 
                                      text: "#{connection_store[:username]} disconnected. (Users: #{user_count})", 
                                      user_count: user_count, 
                                      collected_users: collected_users }
  end
end
  
# private

#   def get_all_users
#     connection_store[:] = connection_store.collect_all(:username).sort!
#   end