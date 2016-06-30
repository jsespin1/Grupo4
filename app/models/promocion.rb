class Promocion < ActiveRecord::Base
  require 'rubygems'
  require 'bunny'
  require 'json'

#11: margarina
#16: Pasta de trigo
#38 : Semilla de maravilla
#44: Agave

  	def self.postFacebook(sku, precio, inicio, fin, codigo)
	    case sku
	    when 11
	      link = 'https://i.ytimg.com/vi/Vrbfyax_T6s/hqdefault.jpg'
	      nombre = "Margarina"
	    when 16
	      link = 'http://www.suraventurabikes.es/wp-content/uploads/2015/10/pastas-de-trigo.jpg'
	      nombre = "Pasta de Trigo"
	    when 38
	      link = 'http://superalimentos.cl/wp-content/uploads/2014/12/Semilla-de-maravilla.jpg'
	      nombre = "Semilla de maravilla"
	    when 44
	      link = 'http://static.imujer.com/sites/default/files/otramedicina/P/Propiedades-del-agave-1.jpg'
	      nombre = "Agave"
	    else
	      link = "https://s-media-cache-ak0.pinimg.com/avatars/pinky19295_1444434602_140.jpg"
	      nombre = "Desconocido"
	    end
	    me = FbGraph::User.me('EAADxZBBU7tuEBADW6oxBGVbOGwznZB2t02aem8cHDxnJMZCmHx67Bh4wHrPGf3OWegji4mIr91PJOaz3lvdHJuiww7BFC55EZCxALp9ZA5SgIVnGlmczFXhDNFqfkCzThLXDVlgBs5h8fh2FYaX929aBq3nRL75sZD')
	    me.feed!(
	      message: "Producto: " << nombre << ', Sku: ' << sku.to_s << ", Precio: " << precio.to_s << ", Fecha Inicio: " << inicio.to_s << ", Fin: " << fin.to_s << ", Código: " << codigo.to_s,
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
		conn.start 
		ch = conn.create_channel 
		q  = ch.queue("ofertas", :auto_delete => true)
		q.subscribe(:block => true, :manual_ack => true) do |delivery_info, properties, payload|
		  json_information_message = JSON.parse(payload)
		  puts "Json info: " << json_information_message.inspect
		  	#nack(delivery_tag, multiple = false, requeue = false)
		  #ch.consumers[delivery_info.consumer_tag].cancel
		  sku = json_information_message['sku']
		  puts "SKU: " << sku.to_s
		  precio = json_information_message['precio']
		  inicio = json_information_message['inicio']
		  inicio = ActiveSupport::TimeZone['America/Santiago'].parse(Date.strptime(inicio.to_s, '%Q').to_s).beginning_of_day
		  fin = json_information_message['fin']
		  fin = ActiveSupport::TimeZone['America/Santiago'].parse(Date.strptime(fin.to_s, '%Q').to_s).end_of_day
		  codigo = json_information_message['codigo']
		  publicar = json_information_message['publicar']
		  publicar = true
		  puts "JSON: " << json_information_message['sku']
		  if codigo.length < 2
			codigo = "Desconocido" << sku.to_s
		  end
		  promo = self.createPromotion(sku, precio, inicio, fin, codigo)
		  if publicar and promo
		  	self.postFacebook(sku, precio, inicio, fin, codigo)
			self.postTwitter(sku, precio, inicio, fin, codigo)
		  end
		  ch.basic_nack(delivery_info.delivery_tag, true, false)
		end
	end

	def self.createPromotion(sku, precio, inicio, fin, codigo)
		puts "Fecha Inicio: " << inicio.to_s
		puts "Fecha Fin: " << fin.to_s
		promo = Spree::Promotion.create(
		  name: codigo,
		  description: "Promocion, sku:" << sku.to_s,
		  match_policy: 'all',
		  starts_at: inicio,
		  expires_at: fin,
		  code: codigo,
		)
		puts "Promocion: " << promo.inspect
		calculator = Spree::Calculator::FlatRate.new
        calculator.preferred_amount = precio
        action = Spree::Promotion::Actions::CreateAdjustment.create!(calculator: calculator)
        promo.actions << action
        promo.save!
		promo
  	end

  def self.postTwitter(sku, precio, inicio, fin, codigo)
    case sku
    when 11
      link = 'https://i.ytimg.com/vi/Vrbfyax_T6s/hqdefault.jpg'
      nombre = "Margarina"
    when 16
      link = 'http://www.suraventurabikes.es/wp-content/uploads/2015/10/pastas-de-trigo.jpg'
      nombre = "Pasta de Trigo"
    when 42
      link = 'http://www.suraventurabikes.es/wp-content/uploads/2015/10/pastas-de-trigo.jpg' 
      nombre = "Pasta de Trigo"
    when 38
      link = 'http://superalimentos.cl/wp-content/uploads/2014/12/Semilla-de-maravilla.jpg'
      nombre = "Semilla de maravilla"
    when 44
      link = 'http://static.imujer.com/sites/default/files/otramedicina/P/Propiedades-del-agave-1.jpg'
      nombre = "Agave"
    else
      link = "https://s-media-cache-ak0.pinimg.com/avatars/pinky19295_1444434602_140.jpg"
      nombre = "Desconocido"
    end
    client = Twitter::REST::Client.new do |config|
      config.consumer_key = 'DtsQzOCl6WxHYypc2Zrl69ULL'
      config.consumer_secret = 'zLiYwfYlCIAYITQ4YoPXX8abUEfDZJTxCf0BgiqbK7egjavHsb'
      config.access_token = '747540484193685504-BVBgqItmbb1dKkT45DQEkTsBgFJzeTZ'
      config.access_token_secret = 'aNKKsfkdl4Gs4UOQvqjLrWVsXt8FNxVkTR9NEkw2faq5G'
    end
    message =  "Producto: " << nombre << ", Precio: " << precio.to_s << "Fecha Inicio: " << inicio.to_s  << ", Código: " << codigo.to_s
    client.update_with_media(message, open(link))
  end


  def self.set_environment
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
