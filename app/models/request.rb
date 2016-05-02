class Request < ActiveRecord::Base


	require 'hmac-sha1'

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

	def self.create_orden(canal, cantidad, sku, cliente, proveedor, precio_unitario, fecha_entrega,notas)
		ruta = URI.parse("http://mare.ing.puc.cl/oc" + "/crear")
		hash = get_hash("PUT"+canal+cantidad+sku+cliente+proveedor+precio_unitario+fecha_entrega)
		query = { canal: canal, cantidad: cantidad, sku: sku, cliente: cliente, proveedor: proveedor, precioUnitario: precio_unitario, fechaEntrega: fecha_entrega, notas: notas }
		orden = HTTParty.put(ruta, :query => query, :headers => hash)
		puts "Orden -> " + orden.inspect
	end

	#def self.date_to_millis(fecha)
    #fecha.strftime('%Q')
  #end

	def self.receive_orden(orden_id)
		ruta = URI.parse("http://mare.ing.puc.cl/oc" + "/recepcionar/" + orden_id)
		hash = {'Content-Type' => "application/json"}
		body = { _id: orden_id }.to_json
		respuesta = HTTParty.post(ruta, :body => body, :headers => hash)
		#puts "Orden -> " + respuesta.inspect
	end

	def self.reject_orden(orden_id, rechazo)
		ruta = URI.parse("http://mare.ing.puc.cl/oc" + "/rechazar/" + orden_id)
		hash = {'Content-Type' => "application/json"}
		body = { _id: orden_id, rechazo: rechazo }.to_json
		respuesta = HTTParty.post(ruta, :body => body, :headers => hash)
		#puts "OrdenRechazo -> " + respuesta.inspect
	end

	def self.annul_orden
	
	end

	def self.obtain_orden

	end

	def self.deliver_orden

	end

end
