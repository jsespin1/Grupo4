class Promocion < ActiveRecord::Base
	require "rubygems"
	require "bunny"
	require "json"


	def self.amqp_consumer
		self.set_environment

		conn = Bunny.new(:host => @host,
		        :vhost => @vhost_user,
		        :user => @vhost_user,
		        :password => @password,
		        :automatically_recover => false
		        )
		puts "Bunny: " << @host << @vhost_user << @password
		#The connection will be established when start is called 
		puts "antes de start"
		conn.start 
		puts "Después de start"
		#Create a channel in the TCP connection
		ch = conn.create_channel 
		puts "Después de create channel"
		#Declare a queue with a given name, examplequeue. In this example is a durable shared queue used.
		q  = ch.queue("ofertas", :auto_delete => true)
		puts "Después de create queue"
		#Set up the consumer to subscribe from the queue
		q.subscribe(:block => true, :manual_ack => true) do |delivery_info, properties, payload|
		  json_information_message = JSON.parse(payload)
		  puts "Json info: " << json_information_message.inspect
		  #if Rails.env == 'development'
		  	#nack(delivery_tag, multiple = false, requeue = false)
		  	ch.basic_nack(delivery_info.delivery_tag, true, true)
		  #end
		  #ch.ack(delivery_info.delivery_tag, true)
		  #ch.consumers[delivery_info.consumer_tag].cancel
		  puts "JSON: " << json_information_message['sku']
		  self.createPromotion(sku, )
		  #mostrar(json_information_message)
		end
	end


	def self.createPromotion

		d = ActiveSupport::TimeZone['America/New_York'].parse(Date.today.to_s)
		promo = Spree::Promotion.create(
		  name: "20% Off",
		  description: "#{d.strftime('%Y-%m-%d')} - 20% off coupon code, automatically generated",
		  event_name: 'spree.checkout.coupon_code_added',
		  match_policy: 'all',
		  starts_at: d,
		  expires_at: (d + 2.weeks).end_of_day,
		  code: "GET20#{SecureRandom.hex(2).upcase}"
		)
		promo.promotion_actions << Spree::Promotion::Actions::CreateAdjustment.create(
		    {calculator: Spree::Calculator::FlatPercentItemTotal.new(preferred_flat_percent: 20)},
		    without_protection: true)
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

	def self.set_environment
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
