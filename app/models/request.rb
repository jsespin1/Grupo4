class Request < ActiveRecord::Base


	require 'hmac-sha1'
	require 'date'

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
		Producto.getProductos(skus.parsed_response, 100)
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
		oc
	end

	def self.create_orden(canal, cantidad, sku, cliente, proveedor, precio_unitario, fecha_entrega, notas)
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

































































































	









	def self.transferir(monto,origen,destino)
		ruta = URI.parse("http://mare.ing.puc.cl/banco" + "/trx")
		hash = { 'Content-type' => "application/json" } # get_hash("PUT"+canal+cantidad.to_s+sku+cliente+proveedor+precio_unitario.to_s+fecha_entrega.to_s+notas)
		puts "hash -> " + hash.to_s
		body = { monto: monto, origen: origen, destino: destino }.to_json
		transferencia = HTTParty.put(ruta, :body => body, :headers => hash)
		puts "transferencia -> " + transferencia.inspect
	end

	def self.obtener_transaccion(transferencia_id)
		ruta = URI.parse("http://mare.ing.puc.cl/banco" + "/trx/" +transferencia_id)
		hash = {'Content-Type' => "application/json"}
		body = { id: transferencia_id }.to_json
		transaccion = HTTParty.get(ruta, :body => body, :headers => hash)
		puts "transaccion -> " + transaccion.inspect
	end

	def self.obtener_cartola(fecha_inicio, fecha_fin, id_cuenta, limite)
		ruta = URI.parse("http://mare.ing.puc.cl/banco" + "/cartola")
		hash = {'Content-Type' => "application/json"}
		body = { fechaInicio: date_to_millis(fecha_inicio), fechaFin: date_to_millis(fecha_fin), id: id_cuenta, limit: limite}.to_json
		respuesta = HTTParty.post(ruta, :body => body, :headers => hash)
		puts "Orden -> " + respuesta.inspect
	end

	def self.obtener_cuenta(id_cuenta)
		ruta = URI.parse("http://mare.ing.puc.cl/banco" + "/cuenta/" + id_cuenta)
		hash = {'Content-Type' => "application/json"}
		body = { _id: id_cuenta}.to_json
		respuesta = HTTParty.get(ruta, :body => body, :headers => hash)
		puts "cuenta -> " + respuesta.inspect

	end


end
