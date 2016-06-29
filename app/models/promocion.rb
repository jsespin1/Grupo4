class Promocion < ActiveRecord::Base
  require 'rubygems'
  require 'bunny'
  require 'json'

#11: margarina
#16: Pasta de trigo
#38 : Semilla de maravilla
#44: Agave

  	def self.postFacebook(sku, precio, inicio, fin, codigo)
  		nombre = "Desconocido"
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
	      sku = 0
	    end

	    inicio = ActiveSupport::TimeZone['America/Santiago'].parse(Date.strptime(inicio.to_s, '%Q').to_s)
	    fin = ActiveSupport::TimeZone['America/Santiago'].parse(Date.strptime(fin.to_s, '%Q').to_s)
	    me = FbGraph::User.me('EAADxZBBU7tuEBADW6oxBGVbOGwznZB2t02aem8cHDxnJMZCmHx67Bh4wHrPGf3OWegji4mIr91PJOaz3lvdHJuiww7BFC55EZCxALp9ZA5SgIVnGlmczFXhDNFqfkCzThLXDVlgBs5h8fh2FYaX929aBq3nRL75sZD')
	    me.feed!(
	      message: "Producto: " << nombre << 'Sku: ' << sku << ", Precio: " << precio << "Fecha Inicio: " << inicio << ", Fin: " << fin << ", Código: " << codigo,
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
		  if Rails.env == 'development'
		  	#nack(delivery_tag, multiple = false, requeue = false)
		  	ch.basic_nack(delivery_info.delivery_tag, true, true)
		  end
		  #ch.ack(delivery_info.delivery_tag, true)
		  #ch.consumers[delivery_info.consumer_tag].cancel
		  sku = json_information_message['sku']
		  precio = json_information_message['precio']
		  inicio = json_information_message['inicio']
		  fin = json_information_message['fin']
		  codigo = json_information_message['codigo']
		  publicar = true
		  puts "JSON: " << json_information_message['sku']
		  if publicar
		  	#self.postFacebook(sku, precio, inicio, fin, codigo)
		  	self.createPromotion(sku, inicio, fin, codigo)
		  end
		  #mostrar(json_information_message)
		end
	end

	def self.createPromotion(sku, precio, inicio, fin, codigo)
		inicio = ActiveSupport::TimeZone['America/New_York'].parse(Date.strptime(inicio.to_s, '%Q').to_s)
		fin = ActiveSupport::TimeZone['America/New_York'].parse(Date.strptime(fin.to_s, '%Q').to_s)
		promo = Spree::Promotion.create(
		  name: codigo,
		  description: "Promocion",
		  match_policy: 'all',
		  starts_at: inicio,
		  expires_at: (inicio + 1.weeks).end_of_day,
		  code: codigo
		)
		puts "Promocion: " << promo.inspect
		calculator = Spree::Calculator::FlatRate.new
        calculator.preferred_amount = precio
        action = Spree::Promotion::Actions::CreateAdjustment.create!(calculator: calculator)
        promo.actions << action
        promo.save!
		#promo.promotion_actions << Spree::Promotion::Actions::CreateAdjustment.create(
		    #{calculator: Spree::Calculator::FlatRate.new(preferred_percent: precio)},
		    #without_protection: true)
  	end

  def self.postTwitter(sku)
    case sku
    when 11
      link = 'https://i.ytimg.com/vi/Vrbfyax_T6s/hqdefault.jpg'
    when 16
      link = 'http://www.suraventurabikes.es/wp-content/uploads/2015/10/pastas-de-trigo.jpg'
    when 42
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
