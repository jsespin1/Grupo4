class Request < ActiveRecord::Base


	require 'hmac-sha1'
	require 'date'

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
		hash = get_hash("GET"+almacenID.to_s)
		query = { almacenId: almacenID.to_s}
		skus = HTTParty.get(ruta, :query => query, :headers => hash)
		Sku.getSkus(skus)
	end

	def self.getStock(almacenID, skuId, cantidad)
		ruta = URI.parse(set_url_bodega + "/stock")
		hash = get_hash("GET"+almacenID.to_s+skuId.to_s)
		query = { almacenId: almacenID, sku: skuId, limit: cantidad.to_i}
		skus = HTTParty.get(ruta, :query => query, :headers => hash)
		Producto.getProductos(skus.parsed_response, cantidad)
	end

	def self.moverStock(prod_id, almacen_id) #Despachar producto: Método que permite marcar los productos despachados de una orden de compra
		ruta = URI.parse(set_url_bodega + "/moveStock")
		hash = get_hash("POST"+prod_id.to_s+almacen_id.to_s)
		body = { productoId: prod_id, almacenId: almacen_id}.to_json
		respuesta = HTTParty.post(ruta, :body => body, :headers => hash)
	end
	
	def self.moverStockFTP(prod_id, direccion, precio, id_oc)
		ruta = URI.parse(set_url_bodega + "/stock")
		hash = get_hash("DELETE"+prod_id.to_s+direccion.to_s+precio.to_s+id_oc.to_s)
		body = { productoId: prod_id, direccion: direccion, precio: precio, oc: id_oc}.to_json
		respuesta = HTTParty.delete(ruta, :body => body, :headers => hash)
		respuesta
	end

	def self.moverStockBodega(prod_id, almacen_id, oc_id, precio) #Despachar producto: Método que permite marcar los productos despachados de una orden de compra
		ruta = URI.parse(set_url_bodega + "/moveStockBodega")
		hash = get_hash("POST"+prod_id.to_s+almacen_id.to_s)
		body = { productoId: prod_id, almacenId: almacen_id, oc: oc_id, precio: precio}.to_json
		respuesta = HTTParty.post(ruta, :body => body, :headers => hash).parsed_response
		respuesta
	end

	def self.getCuentaFabrica
		ruta = URI.parse(set_url_bodega + "/fabrica/getCuenta")
		hash = get_hash("GET")
		cuenta = HTTParty.get(ruta, :body => {}, :headers => hash).parsed_response
	end

	def self.producir(sku, trxId, cantidad)
		ruta = URI.parse(set_url_bodega + "/fabrica/fabricar")
		hash = get_hash("PUT"+sku+cantidad.to_s+trxId)
		body = { sku: sku, trxId: trxId, cantidad: cantidad}.to_json
		produccion = HTTParty.put(ruta, :body => body, :headers => hash)
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
		hash = {'Content-Type' => "application/json"}
		oc = HTTParty.get(ruta, :headers => hash)
		#oc.parsed_response
		Orden.toObject(oc.parsed_response)
	end


	def self.create_orden(canal, cantidad, sku, cliente, proveedor, precio_unitario, fecha_entrega, notas)
		ruta = URI.parse("http://mare.ing.puc.cl/oc" + "/crear")
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


#-----------------------Facturas------------------------#

#Método que sirve para emitir una factura, retorna la factura o un error en caso de existir.
	def self.emitir_factura(orden_id)
		ruta = URI.parse(set_url_fac + "/")
		puts "RUTA -> " + ruta.inspect
		hash = {'Content-Type' => "application/json"}
		body = { oc: orden_id}.to_json
		respuesta = HTTParty.put(ruta, :body => body, :headers => hash)
		#puts "factura -> " + respuesta.inspect
		Factura.toObject(respuesta.parsed_response)
	end

#Método que sirve para obtener una factura dado su id, retorna la factura o un error en caso de existir.
	def self.obtener_factura(factura_id)
		ruta = URI.parse(set_url_fac + "/" + factura_id.to_s)
		hash = {'Content-Type' => "application/json"}
		body = { id: factura_id}.to_json
		respuesta = HTTParty.get(ruta, :body => body, :headers => hash)
		#puts "factura -> " + respuesta.inspect
		Factura.toObject2(respuesta.parsed_response)
	end

#Método que sirve para pagar una factura dado su id, retorna la factura pagada o un error en caso de existir.
	def self.pagar_factura(factura_id)
		ruta = URI.parse(set_url_fac+"/pay")
		hash = {'Content-Type' => "application/json"}
		body = { id: factura_id}.to_json
		respuesta = HTTParty.post(ruta, :body => body, :headers => hash)
		#puts "factura -> " + respuesta.inspect
	end

#Método que sirve para rechazar una factura dado su id, retorna la factura rechazada con un texto que representa el motivo del rechazo o un error en caso de existir.
	def self.rechazar_factura(factura_id, motivo)
		ruta = URI.parse(set_url_fac+"/reject")
		hash = {'Content-Type' => "application/json"}
		body = { id: factura_id, motivo: motivo }.to_json
		respuesta = HTTParty.post(ruta, :body => body, :headers => hash)
		#puts "factura rechazada -> " + respuesta.inspect
	end

#Método que sirve para anular una factura dado su id, retorna la factura anulada con un texto que representa el motivo del rechazo o un error en caso de existir.
	def self.anular_factura(factura_id, motivo)
		ruta = URI.parse(set_url_fac+"/cancel")
		hash = {'Content-Type' => "application/json"}
		body = { id: factura_id, motivo: motivo }.to_json
		respuesta = HTTParty.post(ruta, :body => body, :headers => hash)
	end

#Método que sirve para crear una boleta con el id del proveedor (el de nosotros), un string que representa el id del cliente al que se le hace la boleta y finalmente un int que representa el total de la boleta. Retorna la factura pagada o un error en caso de existir.
	def self.crear_boleta(proveedor_id, cliente_id, total)
		ruta = URI.parse(set_url_fac+"/boleta")
		hash = {'Content-Type' => "application/json"}
		body = { proveedor: proveedor_id, cliente: cliente_id, total: total }.to_json
		respuesta = HTTParty.put(ruta, :body => body, :headers => hash)
		#puts "BOLETA -> " + respuesta.inspect
	end


#-----------------------Transferencias------------------------#
  #------------Requests solo se acceden desde FINANZA--------#

	def self.transferir(monto,origen,destino)
		ruta = URI.parse(set_url_bco + "/trx")
		hash = { 'Content-type' => "application/json" } # get_hash("PUT"+canal+cantidad.to_s+sku+cliente+proveedor+precio_unitario.to_s+fecha_entrega.to_s+notas)
		body = { monto: monto, origen: origen, destino: destino }.to_json
		transferencia = HTTParty.put(ruta, :body => body, :headers => hash)
		Transaccion.toObject(transferencia.parsed_response)
	end

	def self.obtener_transaccion(transferencia_id)
		ruta = URI.parse(set_url_bco + "/trx/" +transferencia_id)
		hash = {'Content-Type' => "application/json"}
		body = { id: transferencia_id }.to_json
		transaccion = HTTParty.get(ruta, :body => body, :headers => hash)
		Transaccion.toObject2(transaccion.parsed_response)
	end

	def self.obtener_cartola(fecha_inicio, fecha_fin, id_cuenta, limite)
		ruta = URI.parse(set_url_bco + "/cartola")
		hash = {'Content-Type' => "application/json"}
		body = { fechaInicio: date_to_millis(fecha_inicio), fechaFin: date_to_millis(fecha_fin), id: id_cuenta, limit: limite}.to_json
		respuesta = HTTParty.post(ruta, :body => body, :headers => hash)
		puts "Orden -> " + respuesta.inspect
	end

	def self.obtener_cuenta(id_cuenta)
		ruta = URI.parse(set_url_bco + "/cuenta/" + id_cuenta)
		hash = {'Content-Type' => "application/json"}
		body = { _id: id_cuenta}.to_json
		respuesta = HTTParty.get(ruta, :body => body, :headers => hash)
		puts "cuenta -> " + respuesta.inspect
	end


#-----------------------API-B2B-------------------------#

	def self.enviarFactura(ruta, idfactura)
        ruta = URI.parse(ruta)
        body = {validado: true, idfactura: idfactura}.to_json
		respuesta = HTTParty.get(ruta, :body => body)
		puts "Esta es la respuesta al envío de la factura " + respuesta.inspect
    end


    def self.consultarStock(url)
	  	ruta = URI.parse(url)
	  	respuesta = HTTParty.get(ruta)
	  	respuesta.parsed_response
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
  


    def self.set_url_fac
        if Rails.env == 'development'
            @url = "http://mare.ing.puc.cl/facturas"
        else
            @url = "http://moto.ing.puc.cl/facturas"
        end
        @url
    end

    def self.set_url_bco
        if Rails.env == 'development'
            @url = "http://mare.ing.puc.cl/banco"
        else
            @url = "http://moto.ing.puc.cl/banco"
        end
        @url
    end





end

