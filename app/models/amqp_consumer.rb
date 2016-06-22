require "rubygems"
require "bunny"
require "json"

#Returns a connection instance
#conn = Bunny.new ENV['CLOUDAMQP_URL']

url="amqp://jvcelgyi:moDjqWMbjzS31KhguvPnCICBEKa6V-4j@hyena.rmq.cloudamqp.com/jvcelgyi"
#Returns a connection instance
#conn = Bunny.new ENV[url]

conn = Bunny.new(:host => "hyena.rmq.cloudamqp.com",
        :vhost => "jvcelgyi",
        :user => "jvcelgyi",
        :password => "moDjqWMbjzS31KhguvPnCICBEKa6V-4j",
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

exit



