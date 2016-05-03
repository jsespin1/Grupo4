class Request < ActiveRecord::Base


	require 'hmac-sha1'
	require "date"

#-----------------------BODEGA/ALMACENES----------------------#

	def self.getAlmacenesAll
		ruta = URI.parse(set_url_bodega + "/almacenes")
		hash = get_hash("GET")
		almacenes = HTTParty.get(ruta, :body => {}, :headers => hash)
		almacenes.to_json
		Almacen.getAlmacenes(almacenes)
	end

	def self.getSKUs(almacenID)
		ruta = URI.parse(set_url_bodega + "/skusWithStock")
		hash = get_hash("GET"+almacenID)
		query = { almacenId: almacenID}
		skus = HTTParty.get(ruta, :query => query, :headers => hash)
		Sku.getSkus(skus)
	end

	def self.getStock(almacenID, skuId)
		ruta = URI.parse(set_url_bodega + "/stock")
		hash = get_hash("GET"+almacenID+skuId)
		query = { almacenId: almacenID, sku: skuId}
		skus = HTTParty.get(ruta, :query => query, :headers => hash)
		Producto.getProductos(skus.parsed_response, 100)
	end

	def  self.get_hash(parametros="")
		 hash = Base64.encode64((HMAC::SHA1.new("tdk6NIzbhNfORDP") << parametros).digest).strip
		 auth_header = { 'Authorization' => "INTEGRACION grupo4:"+hash.to_s,  'Content-Type' => "application/json"}
	end

	def self.get_header1
		header1 = { 'Content-type' => "application/json" }
	end

#-----------------------ORDENES COMPRA----------------------#
	
	def self.getOC(iD)
		ruta = URI.parse(set_url_oc + "/obtener/" + iD.to_s)
		puts "RUTA -> " + ruta.inspect
		hash = {'Content-Type' => "application/json"}
		oc = HTTParty.get(ruta, :headers => hash)
		oc.parsed_response
	end

	def self.create_orden(canal, cantidad, sku, cliente, proveedor, precio_unitario, fecha_entrega,notas)
		ruta = URI.parse(set_url_oc + "/crear")
		hash = { 'Content-type' => "application/json" } # get_hash("PUT"+canal+cantidad.to_s+sku+cliente+proveedor+precio_unitario.to_s+fecha_entrega.to_s+notas)
		puts "hash -> " + hash.to_s
		body = { canal: canal, cantidad: cantidad, sku: sku, cliente: cliente, proveedor: proveedor, precioUnitario: precio_unitario, fechaEntrega: date_to_millis(fecha_entrega), notas: notas }.to_json
		orden = HTTParty.put(ruta, :body => body, :headers => hash)
	end

	def self.date_to_millis(fecha)
    	fecha.strftime('%Q')
  	end
  	

	def self.receive_orden(orden_id)
		ruta = URI.parse(set_url_oc + "/recepcionar/" + orden_id)
		hash = {'Content-Type' => "application/json"}
		body = { _id: orden_id }.to_json
		respuesta = HTTParty.post(ruta, :body => body, :headers => hash)
		#puts "Orden -> " + respuesta.inspect
	end

	def self.reject_orden(orden_id, rechazo)
		ruta = URI.parse(set_url_oc + "/rechazar/" + orden_id)
		hash = {'Content-Type' => "application/json"}
		body = { _id: orden_id, rechazo: rechazo }.to_json
		respuesta = HTTParty.post(ruta, :body => body, :headers => hash)
		#puts "OrdenRechazo -> " + respuesta.inspect
	end
	

	def self.anular_orden(orden_id, motivo)
		ruta = URI.parse(set_url_oc + "/anular/" + orden_id)
		hash = {'Content-Type' => "application/json"}
		body = { _id: orden_id, anulacion: motivo}.to_json
		respuesta = HTTParty.delete(ruta, :body => body, :headers => hash)
		puts "Orden -> " + respuesta.inspect
	end

	def self.obtain_orden

	end

	def self.deliver_orden(orden_id) #Despachar producto: Método que permite marcar los productos despachados de una orden de compra
		ruta = URI.parse(set_url_oc)
		hash = {'Content-Type' => "application/json"}
		body = { _id: orden_id}.to_json
		respuesta = HTTParty.post(ruta, :body => body, :headers => hash)
		puts "Orden -> " + respuesta.inspect

	end


#---------------------------URLs--------------------------#
	def self.set_url_oc
        if Rails.env == 'development'
            @url = "http://mare.ing.puc.cl/oc"
        else
            @url = "http://moto.ing.puc.cl/oc"
        end
        @url
    end

    def self.set_url_bodega
        if Rails.env == 'development'
            @url = "http://integracion-2016-dev.herokuapp.com/bodega"
        else
            @url =  "http://integracion-2016-prod.herokuapp.com/bodega"
        end
        @url
    end

end
