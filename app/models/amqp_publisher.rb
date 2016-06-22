require "rubygems"
require "bunny"
require "json"


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