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
      puts "Se metiooo"
      conn.start 
      puts "Start listo"
      #create a channel in the TCP connection
      ch = conn.create_channel 
      puts "Create Channel listo"
      #Declare a queue with a given name, examplequeue. In this example is a durable shared queue used.
      q  = ch.queue("ofertas", :auto_delete => true)
      puts "Queue Lista"
      #For messages to be routed to queues, queues need to be bound to exchanges.
      x = ch.direct("amq.direct", :auto_delete => true)
      
      #Bind a queue to an exchange
      q.bind(x, :routing_key => "process")
      
      information_message = "{\"sku\": \"38\",\"precio\": \"10000\",\"inicio\": \"1467223779973\",\"fin\": \"1467223779973\",\"codigo\": \"probandoooooo\",\"publicar\": \"true\"}"
      
      x.publish(information_message,
        :timestamp      => Time.now.to_i,
        :routing_key    => "process"
      )
      
      sleep 1.0
      conn.close 