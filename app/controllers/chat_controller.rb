class ChatController < WebsocketRails::BaseController

	def client_connected
    connection_store[:username] = "Chatter #{Random.rand(900) + 100}"
    # testing adding new keys to the connection_store variables. will use later.
    # connection_store[:fav_number] = Random.rand(20)

    collected_users = connection_store.collect_all(:username).sort!
    user_count = collected_users.count

2.times { puts "client_connected"
          puts "================"
          puts "collected_users:  #{collected_users}"
          puts "user_count:       #{user_count}"
          puts "\n" 
        }

    broadcast_message :new_message, { user: "System", text: "New user #{connection_store[:username]} connected!  (Users: #{user_count})", 
                                      user_count: user_count, collected_users: collected_users }
  end

	def send_message
		username = connection_store[:username]
users = connection_store.collect_all(:username).sort!

1.times { message.merge!(username: connection_store[:username]) }
1.times { message.merge!(user_count: users.count) }
1.times { message.merge!(collected_users: users) }
3.times { puts message.inspect + "\n" }
		broadcast_message :new_message, { :user => username, :text => message[:text], 
                                      :user_count => message[:user_count], :collected_users => users }

	end

	def set_name
		connection_store[:username] = message[:name]
	end

  def client_disconnected
    collected_users = connection_store.collect_all(:username).sort!
    user_count = collected_users.count
    broadcast_message :new_message, { :user => "System", :text => "#{connection_store[:username]} disconnected. (Users: #{user_count})", 
                                      user_count: user_count, collected_users: collected_users }
  end
end
