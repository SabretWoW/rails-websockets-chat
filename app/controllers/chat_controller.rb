class ChatController < WebsocketRails::BaseController

	def client_connected
    connection_store[:username] = "Chatter #{Random.rand(1000)}"
    connection_store[:fav_number] = Random.rand(20)

    collected_users = connection_store.collect_all(:username)
    user_count = collected_users.count

2.times { puts "client_connected"
          puts "================"
          puts "collected_users:  #{collected_users}"
          puts "user_count:       #{user_count}"
          puts "\n" 
        }

    broadcast_message :new_message, {:user => "System", :text => "New user #{connection_store[:username]} connected!  (Users: #{user_count})", user_count: user_count }
    # broadcast_message :update_
  end

	def send_message
		username = connection_store[:username]
users = connection_store.collect_all(:username)

1.times { message.merge!(username: connection_store[:username]) }
1.times { message.merge!(user_count: users.count) }
10.times { puts message.inspect + "\n" }
		broadcast_message :new_message, {:user => username, :text => message[:text], :user_count => message[:user_count] }

	end

	def set_name
		connection_store[:username] = message[:name]
	end

  def client_disconnected
    user_count = connection_store.collect_all(:connection_id).count
    broadcast_message :new_message, {:user => "System", :text => "#{connection_store[:username]} disconnected. (Users: #{user_count})", user_count: user_count }
  end
end
