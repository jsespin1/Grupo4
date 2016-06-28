class Promocion < ActiveRecord::Base
  require 'rubygems'
  require 'bunny'
  require 'json'

#11: margarina
#16: Pasta de trigo
#38 : Semilla de maravilla
#44: Agave

  	def self.postFacebook(sku)
	    case sku
	    when 11
	      link = 'https://i.ytimg.com/vi/Vrbfyax_T6s/hqdefault.jpg'
	    when 16
	      link = 'http://www.suraventurabikes.es/wp-content/uploads/2015/10/pastas-de-trigo.jpg'
	    when 38
	      link = 'http://superalimentos.cl/wp-content/uploads/2014/12/Semilla-de-maravilla.jpg'
	    when 44
	      link = 'http://static.imujer.com/sites/default/files/otramedicina/P/Propiedades-del-agave-1.jpg'
	    else
	      sku = 0
	    end

	    me = FbGraph::User.me('EAADxZBBU7tuEBADW6oxBGVbOGwznZB2t02aem8cHDxnJMZCmHx67Bh4wHrPGf3OWegji4mIr91PJOaz3lvdHJuiww7BFC55EZCxALp9ZA5SgIVnGlmczFXhDNFqfkCzThLXDVlgBs5h8fh2FYaX929aBq3nRL75sZD')
	    me.feed!(
	      message: 'prueba',
	      picture: link,
	      link: link,
	      name: 'FbGraph',
	      description: 'A Ruby wrapper for Facebook Graph API'
	    )

    end

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
		  sku = json_information_message['sku']
		  publicar = true
		  puts "JSON: " << json_information_message['sku']
		  if publicar
		  	self.postFacebook(sku)
		  end
		  self.createPromotion(sku, inicio, fin)
		  #mostrar(json_information_message)
		end
	end

  def self.postTwitter(sku)
    case sku
    when 11
      link = 'https://i.ytimg.com/vi/Vrbfyax_T6s/hqdefault.jpg'
    when 16
      link = 'http://www.suraventurabikes.es/wp-content/uploads/2015/10/pastas-de-trigo.jpg'
    when 22
      link = 'http://www.suraventurabikes.es/wp-content/uploads/2015/10/pastas-de-trigo.jpg' 
    when 38
      link = 'http://superalimentos.cl/wp-content/uploads/2014/12/Semilla-de-maravilla.jpg'
    when 44
      link = 'http://static.imujer.com/sites/default/files/otramedicina/P/Propiedades-del-agave-1.jpg'
    else
      sku = 0
    end
    client = Twitter::REST::Client.new do |config|
      config.consumer_key = 'DtsQzOCl6WxHYypc2Zrl69ULL'
      config.consumer_secret = 'zLiYwfYlCIAYITQ4YoPXX8abUEfDZJTxCf0BgiqbK7egjavHsb'
      config.access_token = '747540484193685504-BVBgqItmbb1dKkT45DQEkTsBgFJzeTZ'
      config.access_token_secret = 'aNKKsfkdl4Gs4UOQvqjLrWVsXt8FNxVkTR9NEkw2faq5G'
    end
    client.update_with_media('PRUEBA', open(link))
  end

  def self.createPromotion(sku, inicio, fin)

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

  def set_environment
    if Rails.env == 'development'
      @url = 'amqp://jvcelgyi:moDjqWMbjzS31KhguvPnCICBEKa6V-4j@hyena.rmq.cloudamqp.com/jvcelgyi'
      @host = 'hyena.rmq.cloudamqp.com'
      @vhost_user = 'jvcelgyi'
      @password = 'moDjqWMbjzS31KhguvPnCICBEKa6V-4j'
    else
      @url = 'amqp://ecgypzyb:tvgB-JFYXhm30AW3Mm2wLB9v5998HWTT@fox.rmq.cloudamqp.com/ecgypzyb'
      @host = 'fox.rmq.cloudamqp.com'
      @vhost_user = 'ecgypzyb'
      @password = 'tvgB-JFYXhm30AW3Mm2wLB9v5998HWTT'
    end
   end

 

end
