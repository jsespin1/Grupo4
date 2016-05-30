class Controlador < ActiveRecord::Base

	#A este metodo le llega un id de orden de compra desde pedidos
	def self.procesar_oc(id)
		#primero se crea, con el id, la orden
		@oc = Request.getOC(id)[0]
		#luego se debe revisar el stock, sumando todos los almacenes
		sku = @oc['sku'].to_i
		cantidadDespachada = @oc['cantidadDespachada'].to_i
		cantidad = @oc['cantidad'].to_i
		total = Almacen.getSkusTotal(sku).to_i

	end

	def self.validarTransaccion(idTrx, idFactura)
	  	factura=Request.obtener_factura(idFactura)
	  	trx=Request.obtener_transaccion(idTrx)
	  	boolean=false
	  	if factura.valor_total==trx.monto and (trx.cuenta_destino.eql? Finanza.getCuentaPropia)
	  		boolean = true
	  	end
	 	boolean
	end


	def self.facturaFicticio(idOC)
		#ESTO GATILLA TODO EL PROCESO FICTICIO
		#Primero se recepciona orden de compra
		response = Request.receive_orden(idOC)
		#Obtenemos orden de compra
		oc = Request.getOC(idOC)
		#Generamos la factura
		factura = Request.emitir_factura(idOC)
		#Si la factura ya existe, obtenemos nil
		idFactura = ""
		idGrupo = ""
		if factura == nil
			#idFactura = oc.idfactura
		else
			idFactura = factura._id
			idGrupo = factura.proveedor

		end
		puts "Factura -> " + idFactura
		Request.pagar_factura(idFactura)
		cuentaDestino(idGrupo)
		#Nuestra Cuenta
		@cuentaDestino = "571262c3a980ba030058ab5f"
		#Ahora generamos la transaccion, para probar lo haremos con nostros mismos
		transferencia = Request.transferir(3, @cuentaDestino, @cuentaDestino)
		#Ahora llamamos al metodo que deberia llamar la API cuando se envia transferencia y factura
		procesarPago(transferencia._id, factura._id)
	end


	def self.procesarPago(id_trans, id_factura)
		despachado = false
		factura = Request.obtener_factura(id_factura)
		transferencia = Request.obtener_transaccion(id_trans)
		id_oc = factura.id_oc
		oc = Request.getOC(id_oc)
		if transferencia.monto <=  factura.valor_total
			if oc.cantidad >= Almacen.getSkusTotal(oc.sku)
			#Ahora, que esta pagado, procedemos a revisar stock, en el caso que haya, despachamos, si no, no
				moverBodegaDespacho(oc.sku, 2, oc)

			end
		end
		despachado
	end

	def self.getStock(id)
		#se debe revisar el stock, sumando todos los almacenes
		total = Almacen.getSkusTotal(id).to_i
	end

	def self.validarTrx(id)
		transaccion = Request.obtener_transaccion(id)
	end


	def self.facturar(idCliente, idFactura)
		grupo = getGrupo(idCliente)
		if grupo.to_i != 0
			#Ahora simplemente debemos enviar la ruta correspondiente
			#Delegamos el request a la clase request
			ruta = "http://integra" + grupo.to_s + ".ing.puc.cl/api/facturas/recibir/" + idFactura.to_s
			Request.enviarFactura(ruta, idFactura)
		end
	end

	def self.enviar_transaccion(id_trx, id_factura, idCliente)
		grupo = getGrupo(idCliente)
		ruta = "http://integra" + grupo.to_s + ".ing.puc.cl/api/pagos/recibir/" + id_trx.to_s
		Request.enviarTransaccion(ruta, id_factura)
	end


	def self.getGrupo(id)
		retornar = 0
		array_grupos
		@array_grupos.each do |g|
			if g[:id].eql? id.to_s
				retornar = g[:grupo]
			end
		end
		retornar
	end

	def self.cuentaDestino(id)
		cuentaDestino = ""
		array_grupos
		@array_grupos.each do |g|
			if g[:id].eql? id
				cuentaDestino = g[:cuenta]
			end
		end
		cuentaDestino
	end

	def self.getDestino(id)
		id_destino = ""
		array_grupos
		@array_grupos.each do |g|
			if g[:id].eql? id
				id_destino = g[:id_despacho]
			end
		end
		id_destino
	end


	def self.array_grupos
		if Rails.env == 'development'
            @array_grupos = [
        {id: "571262b8a980ba030058ab4f", grupo: 1, cuenta: "571262c3a980ba030058ab5b", id_despacho: "571262aaa980ba030058a147"},
        {id: "571262b8a980ba030058ab50", grupo: 2, cuenta: "571262c3a980ba030058ab5c", id_despacho: "571262aaa980ba030058a14e"},
        {id: "571262b8a980ba030058ab51", grupo: 3, cuenta: "571262c3a980ba030058ab5d", id_despacho: "571262aaa980ba030058a1f1"},
        {id: "571262b8a980ba030058ab52", grupo: 4, cuenta: "571262c3a980ba030058ab5f", id_despacho: "571262aaa980ba030058a23f"},
        {id: "571262b8a980ba030058ab53", grupo: 5, cuenta: "571262c3a980ba030058ab61", id_despacho: "571262aaa980ba030058a244"},
        {id: "571262b8a980ba030058ab54", grupo: 6, cuenta: "571262c3a980ba030058ab62", id_despacho: ""},
        {id: "571262b8a980ba030058ab55", grupo: 7, cuenta: "571262c3a980ba030058ab60", id_despacho: ""},
        {id: "571262b8a980ba030058ab56", grupo: 8, cuenta: "571262c3a980ba030058ab5e", id_despacho: "571262aaa980ba030058a31e"},
        {id: "571262b8a980ba030058ab57", grupo: 9, cuenta: "571262c3a980ba030058ab66", id_despacho: "571262aaa980ba030058a3b0"},
        {id: "571262b8a980ba030058ab58", grupo: 10, cuenta: "571262c3a980ba030058ab63", id_despacho: "571262aaa980ba030058a40c"},
        {id: "571262b8a980ba030058ab59", grupo: 11, cuenta: "571262c3a980ba030058ab64", id_despacho: "571262aaa980ba030058a488"},
        {id: "571262b8a980ba030058ab5a", grupo: 12, cuenta: "571262c3a980ba030058ab65", id_despacho: "571262aba980ba030058a5c6"}
      ]
        else
            @array_grupos = [
        {id: "572aac69bdb6d403005fb042", grupo: 1, cuenta: "572aac69bdb6d403005fb04e", id_despacho: "572aad41bdb6d403005fb066"},
        {id: "572aac69bdb6d403005fb043", grupo: 2, cuenta: "572aac69bdb6d403005fb04f", id_despacho: "572aad41bdb6d403005fb0ba"},
        {id: "572aac69bdb6d403005fb044", grupo: 3, cuenta: "572aac69bdb6d403005fb050", id_despacho: "572aad41bdb6d403005fb1bf"},
        {id: "572aac69bdb6d403005fb045", grupo: 4, cuenta: "572aac69bdb6d403005fb051", id_despacho: "572aad41bdb6d403005fb208"},
        {id: "572aac69bdb6d403005fb046", grupo: 5, cuenta: "572aac69bdb6d403005fb052", id_despacho: "572aad41bdb6d403005fb278"},
        {id: "572aac69bdb6d403005fb047", grupo: 6, cuenta: "572aac69bdb6d403005fb053", id_despacho: "572aad41bdb6d403005fb2d8"},
        {id: "572aac69bdb6d403005fb048", grupo: 7, cuenta: "572aac69bdb6d403005fb054", id_despacho: "572aad41bdb6d403005fb3b9"},
        {id: "572aac69bdb6d403005fb049", grupo: 8, cuenta: "572aac69bdb6d403005fb056", id_despacho: "572aad41bdb6d403005fb416"},
        {id: "572aac69bdb6d403005fb04a", grupo: 9, cuenta: "572aac69bdb6d403005fb057", id_despacho: "572aad41bdb6d403005fb4b8"},
        {id: "572aac69bdb6d403005fb04b", grupo: 10, cuenta: "572aac69bdb6d403005fb058", id_despacho: "572aad41bdb6d403005fb542"},
        {id: "572aac69bdb6d403005fb04c", grupo: 11, cuenta: "572aac69bdb6d403005fb059", id_despacho: "572aad41bdb6d403005fb5b9"},
        {id: "572aac69bdb6d403005fb04d", grupo: 12, cuenta: "572aac69bdb6d403005fb05a", id_despacho: "572aad42bdb6d403005fb69f"}
      ]
        end
  end

  def self.getPrecio(sku)
  	precios
  	precio=0
  	@array_precios.each do |p|
  		sku2=p[:sku]
  		if sku.eql? sku2
  			precio = p[:precio]
  		end
  	end
  	precio
  end

  def self.precios
  	@array_precios = [
        {sku: "11", precio: 6238},
        {sku: "16", precio: 9793},
        {sku: "38", precio: 1513},
        {sku: "44", precio: 1254}
      ]

  end
  
  


end
