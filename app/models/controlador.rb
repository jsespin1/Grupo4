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

	def self.facturaFicticio(idOC)
		#ESTO GATILLA TODO EL PROCESO FICTICIO
		#Primero se recepciona orden de compra
		response = Request.receive_orden(idOC)
		#Obtenemos orden de compra
		oc = Request.getOC(idOC)
		puts "OC -> " + oc._id
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


	#def self.moverBodegaDespacho(sku, cantidad, oc)
		#puts "Comenzamos a Mover " + sku
		#despachados = 0
		#id_despacho = Almacen.getIdDespacho
		#precio = getPrecio(sku)
		#id_destino = getDestino(oc.cliente)
		#@almacenes = Request.getAlmacenesAll
		#@almacenes.each do |a|
			#if a.despacho == false
				#array_productos = Request.getStock(a._id, sku)
				#array_productos.each do |p|
					#if despachados < cantidad 
						#Request.moverStock(p, id_despacho)
						#Request.moverStockBodega(p, id_destino, oc._id, precio)
						#despachados = despachados + 1
					#end
				#end
			#end
		#end
	#end


	def self.getStock(id)
		#se debe revisar el stock, sumando todos los almacenes
		total = Almacen.getSkusTotal(id).to_i
	end

	def self.validarTrx(id)
		transaccion = Request.obtener_transaccion(id)
	end


	def self.facturar(idCliente, idFactura)
		grupo = getGrupo(idCliente)
		if grupo != 0
			#Ahora simplemente debemos enviar la ruta correspondiente
			#Delegamos el request a la clase request
			ruta = "http://integra" + grupo.to_s + ".ing.puc.cl/api/facturas/recibir/" + idFactura.to_s
			Request.enviarFactura(ruta, idFactura)
		end
	end


	def self.getGrupo(id)
		retornar = 0
		array_grupos
		@array_grupos.each do |g|
			if g['id']==id
				retornar = g['grupo']
			end
		end
		retornar
	end

	def self.cuentaDestino(id)
		@cuentaOrigen = "571262c3a980ba030058ab5f"
		array_grupos
		@array_grupos.each do |g|
			if g['id']==id
				@cuentaDestino = g['cuenta']
			end
		end
	end

	def self.getDestino(id)
		id_destino = ""
		array_grupos
		@array_grupos.each do |g|
			if g['id']==id
				id_destino = g['id_despacho']
			end
		end
		id_destino
	end


	def self.array_grupos
    @array_grupos = [
        {id: "571262b8a980ba030058ab4f", grupo: 1, cuenta: "571262c3a980ba030058ab5b", id_despacho: "571262aaa980ba030058a147"},
        {id: "571262b8a980ba030058ab50", grupo: 2, cuenta: "571262c3a980ba030058ab5c", id_despacho: "571262aaa980ba030058a14e"},
        {id: "571262b8a980ba030058ab51", grupo: 3, cuenta: "571262c3a980ba030058ab5d", id_despacho: ""},
        {id: "571262b8a980ba030058ab53", grupo: 5, cuenta: "571262c3a980ba030058ab61", id_despacho: ""},
        {id: "571262b8a980ba030058ab54", grupo: 6, cuenta: "571262c3a980ba030058ab62", id_despacho: ""},
        {id: "571262b8a980ba030058ab55", grupo: 7, cuenta: "571262c3a980ba030058ab60", id_despacho: ""},
        {id: "571262b8a980ba030058ab56", grupo: 8, cuenta: "571262c3a980ba030058ab5e", id_despacho: "571262aaa980ba030058a31e"},
        {id: "", grupo: 9, cuenta: "asjkfbjkasf", id_despacho: ""},
        {id: "571262b8a980ba030058ab58", grupo: 10, cuenta: "571262c3a980ba030058ab63", id_despacho: "571262aaa980ba030058a40c"},
        {id: "571262b8a980ba030058ab59", grupo: 11, cuenta: "571262c3a980ba030058ab64", id_despacho: "571262aaa980ba030058a488"},
        {id: "571262b8a980ba030058ab5a", grupo: 12, cuenta: "asjkfbjkasf", id_despacho: ""}
      ]
  end

  def self.getPrecio(sku)
  	precios
  	precio = 0
  	@array_precios.each do |p|
  		if sku==p['sku']
  			precio = p['precio']
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
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  def self.validarTransaccion(idTrx, idFactura)
  	factura=Request.obtener_factura(idFactura)
  	trx=Request.obtener_transaccion(idTrx)
  	boolean=false
  	if factura.valor_total==trx.monto
  		boolean = true
  		boolean
  	end
 		boolean
  end

  
  
  
  



end
