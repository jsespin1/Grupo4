class Request < ActiveRecord::Base


	require 'hmac-sha1'
	require "date"

	#Bodegas
	clave_bodega = "tdk6NIzbhNfORDP"
	route_bodega = "http://integracion-2016-dev.herokuapp.com/bodega"

	def self.getAlmacenesAll
		ruta = URI.parse("http://integracion-2016-dev.herokuapp.com/bodega" + "/almacenes")
		hash = get_hash("GET")
		almacenes = HTTParty.get(ruta, :body => {}, :headers => hash)
		almacenes.to_json
		Almacen.getAlmacenes(almacenes)
	end

	def self.getSKUs(almacenID)
		ruta = URI.parse("http://integracion-2016-dev.herokuapp.com/bodega" + "/skusWithStock")
		hash = get_hash("GET"+almacenID)
		query = { almacenId: almacenID}
		skus = HTTParty.get(ruta, :query => query, :headers => hash)
		Sku.getSkus(skus)
	end

	def self.getStock(almacenID, skuId)
		ruta = URI.parse("http://integracion-2016-dev.herokuapp.com/bodega" + "/stock")
		hash = get_hash("GET"+almacenID+skuId)
		query = { almacenId: almacenID, sku: skuId}
		skus = HTTParty.get(ruta, :query => query, :headers => hash)
		puts "Stock -> " + skus.parsed_response.count.to_s
	end

	def  self.get_hash(parametros="")
		 hash = Base64.encode64((HMAC::SHA1.new("tdk6NIzbhNfORDP") << parametros).digest).strip
		 auth_header = { 'Authorization' => "INTEGRACION grupo4:"+hash.to_s,  'Content-Type' => "application/json"}
	end

	def self.get_header1
		header1 = { 'Content-type' => "application/json" }
	end
	
	def self.getOC(iD)
		ruta = URI.parse("http://mare.ing.puc.cl/oc/obtener" + iD.to_s)
		hash = {'Content-Type' => "application/json"}
		oc = HTTParty.get(ruta, :headers => hash)
		puts oc.inspect
		oc
	end

	def self.create_orden(canal, cantidad, sku, cliente, proveedor, precio_unitario, fecha_entrega,notas)
		ruta = URI.parse("http://mare.ing.puc.cl/oc" + "/crear")
		hash = { 'Content-type' => "application/json" } # get_hash("PUT"+canal+cantidad.to_s+sku+cliente+proveedor+precio_unitario.to_s+fecha_entrega.to_s+notas)
		puts "hash -> " + hash.to_s
		body = { canal: canal, cantidad: cantidad, sku: sku, cliente: cliente, proveedor: proveedor, precioUnitario: precio_unitario, fechaEntrega: date_to_millis(fecha_entrega), notas: notas }.to_json
		orden = HTTParty.put(ruta, :body => body, :headers => hash)
		puts "Orden -> " + orden.inspect
	end

	def self.date_to_millis(fecha)
    	fecha.strftime('%Q')
  	end
  	

	def self.receive_orden

	end

	def self.reject_orden
	
	end
	

	def self.anular_orden(orden_id, motivo)
		ruta = URI.parse("http://mare.ing.puc.cl/oc" + "/anular/" + orden_id)
		hash = {'Content-Type' => "application/json"}
		body = { _id: orden_id, anulacion: motivo}.to_json
		respuesta = HTTParty.delete(ruta, :body => body, :headers => hash)
		puts "Orden -> " + respuesta.inspect
	end

	def self.obtain_orden

	end

	def self.deliver_orden(orden_id) #Despachar producto: Método que permite marcar los productos despachados de una orden de compra

		ruta = URI.parse("http://mare.ing.puc.cl/oc")
		hash = {'Content-Type' => "application/json"}
		body = { _id: orden_id}.to_json
		respuesta = HTTParty.post(ruta, :body => body, :headers => hash)
		puts "Orden -> " + respuesta.inspect

	end

end
