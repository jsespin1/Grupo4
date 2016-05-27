class Almacen < ActiveRecord::Base

	has_many :skus

	def self.getAlmacenes(almacenes)
		arreglo = []
		almacenes.each do |b|
			a = Almacen.new(:_id => b['_id'], :grupo => b['grupo'], :pulmon => b['pulmon'], 
				:despacho => b['despacho'], :recepcion => b['recepcion'], :totalSpace => b['totalSpace'], 
				:usedSpace => b['usedSpace'], :v => b['__v'])
			arreglo.push(a)
		end
		arreglo
	end


	def self.getIdDespacho
		id = "0"
		@almacenes = Request.getAlmacenesAll
		@almacenes.each do |a|
			if a.despacho
				id = a._id
			end
		end
		id
	end

	def self.getIdPulmon # retorna el id de pulmon.
		#Primero se obtienen todos los skus
		id = "0"
		@almacenes = Request.getAlmacenesAll
		@almacenes.each do |a|
			if a.pulmon
				id = a._id
			end
		end
		id
	end


	def self.getSkusTotal(idSku)
		#Primero se obtienen todos los skus
		@almacenes = Request.getAlmacenesAll
		total = 0
		@almacenes.each do |a|
			#obtenemos los skus para el almacen
			skus = Request.getSKUs(a._id)
			skus.each do |s|
				if s._id.to_i == idSku.to_i
					total += s.cantidad.to_i
				end
			end
		end
		total
	end

	
	def self.moverAlmacenRecepcion(sku)
  		
		id_almacen = getAlmacenRecepcion
  		puts "Comenzamos a Mover (recepcion)" + sku
		movidos = 0
		@almacenes = Request.getAlmacenesAll
		array_productos = Request.getStock(id_almacen, sku)
		cantidad_productos=0
		cantidad_productos = array_productos.length
		productos_delete=[]
		@almacenes.each do |a|
			if a.despacho == false and a.recepcion == false and a.pulmon == false 
				if a.usedSpace < a.totalSpace and movidos < cantidad_productos 
					array_productos.each do |p|
						Request.moverStock(p, a._id)
						puts "se movio " + p + "al almacen " +a._id
						movidos=movidos+1
						puts "movidos " + movidos.to_s + " cantidad_productos " + cantidad_productos.to_s + " largo array " + array_productos.length.to_s
						productos_delete.push(p)
						#array_productos.delete(p)
					end
				end
				puts "salio del loop :("
				productos_delete.each do |d|
					array_productos.delete(d)
				end
			end
		end
	end

  
  def self.revisarAlmacenRecepcion
  	id_almacen = getAlmacenRecepcion
  	puts "id almacen -> " + id_almacen
  	arreglo_skus = Request.getSKUs(id_almacen.to_s)
  	if arreglo_skus.length > 0
  		arreglo_skus.each do |s|
  			puts "se deberia mover -> " + s._id.to_s + s.cantidad.to_s
  			moverAlmacenRecepcion(s._id)
  		end
  	end
  end


	
	def self.getAlmacenRecepcion
		id = "0"
		@almacenes = Request.getAlmacenesAll
		@almacenes.each do |a|
			if a.recepcion
				id = a._id
			end
		end
		id
	end

	def self.verificar_stock_despacho(cantidad,sku)
		total = 0
		id_despacho = getIdDespacho
		skus = Request.getSKUs(id_despacho)
		skus.each do |s|
			if s._id.to_i == sku.to_i
				total = s.cantidad.to_i
			end
		end
		total >= cantidad.to_i
	end
	

	def self.verificar_stock_sin_pulmon(cantidad,sku)
		@almacenes = Request.getAlmacenesAll
		total = 0
		@almacenes.each do |a|
			if a.pulmon == false
				skus = Request.getSKUs(a._id)
				skus.each do |s|
					if s._id.to_i == sku.to_i
						total += s.cantidad.to_i
					end
				end
			end
		total > cantidad
		end
	end


	def self.verificar_stock_con_pulmon(cantidad,sku)
		@almacenes = Request.getAlmacenesAll
		total = 0
		@almacenes.each do |a|
				skus = Request.getSKUs(a._id)
				skus.each do |s|
					if s._id.to_i == sku.to_i
						total += s.cantidad.to_i
					end
				end
			end
		total > cantidad
	end

	def self.getDisponible(id_almacen, id_sku)
		#Primero se obtienen todos los skus
		total = 0
		skus = Request.getSKUs(id_almacen)
		skus.each do |s|
			if s._id.to_i == id_sku.to_i
				total += s.cantidad.to_i
			end
		end
		total
	end

	def self.moverAlmacenDespacho(sku,cantidad)
	  	movidos = 0
	  	id_despacho = getIdDespacho
	  	almacenes = Request.getAlmacenesAll
	  	almacenes.each do |almacen|
	  		if almacen.despacho == false and movidos<cantidad
	  			#obtenemos los skus para el almacen
	  			disponibles = getDisponible(almacen._id, sku) 
	  			faltantes = (cantidad.to_i - movidos.to_i).to_i
	  			cantidad_a_mover = 0
	  			if disponibles >= faltantes
	  				cantidad_a_mover = faltantes
	  			else
	  				cantidad_a_mover = disponibles.to_i	
	  			end
	  			movidos_almacen = 0
	  			while (movidos_almacen.to_i < cantidad_a_mover.to_i)
	  				array_productos = Request.getStock(almacen._id, sku, (cantidad_a_mover-movidos_almacen).to_i)
					array_productos.each do |p|
						hay_espacio = Request.moverStock(p, id_despacho)
						#if !hay_espacio
						#	puts "El mover Stock FTP problema" + hay_espacio.inspect
						#	break
						#end
						movidos_almacen = movidos_almacen + 1
						movidos = movidos + 1
					end
	  			end	  
	  		end
	  	end
	  	"Se movieron a Despacho: " + movidos.to_s
	end

	def self.moverBodegaFTP(cantidad, sku, oc)
		id_despacho = getIdDespacho
		cuenta = 0
		puts "Despachando FTP, Cantidad: " + cantidad.to_s + ", SKU: " + sku.to_s
		while cuenta.to_i < cantidad.to_i
			array_productos = Request.getStock(id_despacho, sku, (cantidad-cuenta).to_i)
			array_productos.each do |p|
				hay_espacio = Request.moverStockFTP(p, oc.cliente, oc.precio_unitario, oc._id)
				#if !hay_espacio
					#	puts "El mover Stock FTP problema" + hay_espacio.inspect
					#	break
				#end
				cuenta = cuenta + 1
			end
		end
		Orden.cambiarEstado(oc._id, "finalizada")
		Orden.cambiarCantidad(oc._id, cantidad)
		#Request.deliver_orden(id_oc)
		cuenta
	end
	
	def self.moverBodegaWEB(cantidad, sku, boletum)
		id_despacho = getIdDespacho
		cuenta = 0
		puts "Despachando FTP, Cantidad: " + cantidad.to_s + ", SKU: " + sku.to_s
		while cuenta.to_i < cantidad.to_i
			array_productos = Request.getStock(id_despacho, sku, (cantidad-cuenta).to_i)
			array_productos.each do |p|
				hay_espacio = Request.moverStockFTP(p, boletum.direccion, Controlador.getPrecio(boletum.sku), boletum.idboleta)
				#if !hay_espacio
					#	puts "El mover Stock FTP problema" + hay_espacio.inspect
					#	break
				#end
				cuenta = cuenta + 1
			end
		end
	
		cuenta
	end
	
	def self.moverBodegaB2B(cantidad, sku, oc)
		puts "Mover Bodega Despachando B2B | cantidad: " + cantidad.to_s + "| SKU: " + sku.to_s
		id_despacho = getIdDespacho
		id_cliente=oc.cliente
		almacen_destino=Controlador.getDestino(id_cliente)
		cuenta=0
		while cuenta.to_i < cantidad.to_i
			puts "Cuenta: " + cuenta.to_s
			array_productos = Request.getStock(id_despacho, sku, (cantidad-cuenta).to_i)
			array_productos.each do |p|
				hay_espacio = Request.moverStockBodega(p, almacen_destino, oc._id, oc.precio_unitario)
				condicion = "Traspaso no realizado debido a falta de espacio"
				#if respuesta['error'].eql? condicion
				#hay que vaciar despacho
				#	break
				#elsif respuesta['error']
				#	break
				#end
				cuenta = cuenta + 1
			end
		end
		#Request.deliver_orden(id_oc)
		Orden.cambiarEstado(oc._id, "finalizada")
		Orden.cambiarCantidad(oc._id, cantidad)
		cuenta
	end


	#revisa la forma en que se saca el stock para moverlo a despacho
	def self.revisarFormaDeDespacho(cantidad, sku, orden)
		puts "Despachando -> | Cantidad: " + cantidad.to_s+" | SKU:  "+sku+" | OC: "+orden._id
		if Almacen.verificar_stock_despacho(cantidad, sku)
			canal="ftp"
			if orden.canal.eql? canal
				puts "SE METIO A FTP DESPACHO"
				cantidad = moverBodegaFTP(cantidad, sku, orden)
			end
			canal="b2b"
			if orden.canal.eql? canal
				puts "SE METIO A B2B DESPACHO"
				cantidad = moverBodegaB2B(cantidad, sku, orden)
			end
		elsif Almacen.verificar_stock_sin_pulmon(cantidad,sku)
			moverAlmacenDespacho(sku,cantidad)
			canal="b2b"
			if orden.canal.eql? canal
				puts "SE METIO A FTP SIN PULMON"
				cantidad = moverBodegaB2B(cantidad, sku, orden)
			end
			canal="ftp"
			if orden.canal.eql? canal
				"SE METIO A B2B SIN PULMON"
				cantidad = moverBodegaFTP(cantidad, sku, orden)
			end

					#despachar 
		elsif Almacen.verificar_stock_con_pulmon(cantidad,sku)
			moverAlmacenDespacho(sku,cantidad)
			canal="b2b"
			if orden.canal.eql? canal
				puts "SE METIO A FTP CON PULMON"
				cantidad = moverBodegaB2B(cantidad, sku, orden)
			end
			canal="ftp"
			if orden.canal.eql? canal
				"SE METIO A B2B CON PULMON"
				cantidad = moverBodegaFTP(cantidad, sku, orden)
			end
		else 
						
		end

		puts "Se despacharon -> " + cantidad.to_s
		cantidad

	end
	
end




















