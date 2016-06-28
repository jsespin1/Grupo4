class Promocion < ActiveRecord::Base
	require "rubygems"
	require "bunny"
	require "json"


	def self.amqp_consumer
		set_environment

		conn = Bunny.new(:host => @host,
		        :vhost => @vhost_user,
		        :user => @vhost_user,
		        :password => @password,
		        :automatically_recover => false
		        )
		#The connection will be established when start is called 
		conn.start 
		#Create a channel in the TCP connection
		ch = conn.create_channel 
		#Declare a queue with a given name, examplequeue. In this example is a durable shared queue used.
		q  = ch.queue("ofertas", :durable => true)
		#Set up the consumer to subscribe from the queue
		q.subscribe(:block => true, :manual_ack => true) do |delivery_info, properties, payload|
		  json_information_message = JSON.parse(payload)
		  puts "es un loop"
		  puts "Json info: " << json_information_message.inspect
		  #if Rails.env == 'development'
		  	#nack(delivery_tag, multiple = false, requeue = false)
		  	ch.basic_nack(delivery_info.delivery_tag, true, false)
		  #end
		  #ch.ack(delivery_info.delivery_tag, true)
		  #ch.consumers[delivery_info.consumer_tag].cancel
		  puts "delivery_info: " << delivery_info.inspect
		  puts "Properties: " << properties.inspect
		  #mostrar(json_information_message)
		end
	end


	def self.amqp_publisher
		set_environment
		conn = Bunny.new(:host => @host,
	        :vhost => @vhost_user,
	        :user => @vhost_user,
	        :password => @password,
	        :automatically_recover => false
	        )
		#The connection will be established when start is called
		conn.start 
		#create a channel in the TCP connection
		ch = conn.create_channel 
		#Declare a queue with a given name, examplequeue. In this example is a durable shared queue used.
		q  = ch.queue("ofertas", :durable => true)
		#For messages to be routed to queues, queues need to be bound to exchanges.
		x = ch.direct("amq.direct", :durable => true)
		#Bind a queue to an exchange
		q.bind(x, :routing_key => "process")

		information_message = "{\"email\": \"example@mail.com\",\"name\": \"name\",\"size\": \"size\"}"

		x.publish(information_message,
		  :timestamp      => Time.now.to_i,
		  :routing_key    => "process"
		)
		sleep 1.0
		conn.close
	end

	private

	def set_environment
		if Rails.env == 'development'
            @url = "amqp://jvcelgyi:moDjqWMbjzS31KhguvPnCICBEKa6V-4j@hyena.rmq.cloudamqp.com/jvcelgyi"
            @host = "hyena.rmq.cloudamqp.com"
            @vhost_user = "jvcelgyi"
            @password = "moDjqWMbjzS31KhguvPnCICBEKa6V-4j"
        else
            @url = "amqp://ecgypzyb:tvgB-JFYXhm30AW3Mm2wLB9v5998HWTT@fox.rmq.cloudamqp.com/ecgypzyb"
            @host = "fox.rmq.cloudamqp.com"
            @vhost_user = "ecgypzyb"
            @password = "tvgB-JFYXhm30AW3Mm2wLB9v5998HWTT"
        end
	end



end
