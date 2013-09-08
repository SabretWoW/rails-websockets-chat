class ChatController < WebsocketRails::BaseController

	def client_connected
    connection_store[:screen_name] = "Chatter #{Random.rand(1000)}"
    broadcast_message :new_message, {:user => "System", :text => "New user #{connection_store[:screen_name]} connected!" }
    
  end

	def send_message
		screen_name = connection_store[:screen_name]
		broadcast_message :new_message, {:user => screen_name, :text => message[:text]}
	end

	def set_name
		connection_store[:screen_name] = message[:name]
	end

  def client_disconnected
    broadcast_message :new_message, {:user => "System", :text => "#{connection_store[:screen_name]} disconnected." }
  end
end
