class Almacen < ActiveRecord::Base

	has_many :skus

	def self.getAlmacenes(almacenes)
		arreglo = []
		almacenes.each do |b|
			puts "Almacene -> " +b.inspect
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

  
  def self.moverAlmacenDespacho(sku,cantidad)
  	cantidad_a_mover = cantidad.to_i
  	despachados = 0
  	id_despacho = getIdDespacho
  	almacenes = Request.getAlmacenesAll
  	almacenes.each do |almacen|
  		if almacen.despacho == false			  
  			array_productos = Request.getStock(almacen._id,sku, cantidad)
  			array_productos.each do |producto|
  				if despachados < cantidad_a_mover
  					Request.moverStock(producto, id_despacho)
  					despachados = despachados + 1
  				end
  			end
  		end
  		"Se despacharon a Despacho: " + despachados.to_s
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
		total > cantidad.to_i
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

	def self.moverBodegaFTP(cantidad, sku, id_oc)
		id_despacho = getIdDespacho
		oc=Request.getOC(id_oc)
		cuenta = 0
		begin
			array_productos = Request.getStock(id_despacho, sku, (cantidad-cuenta).to_i)
				array_productos.each do |p|
					hay_espacio = Request.moverStockFTP(p, oc.cliente, oc.precio_unitario,id_oc)
					#if !hay_espacio
					#	puts "El mover Stock FTP problema" + hay_espacio.inspect
					#	break
					#end
					cuenta = cuenta + 1
				end
		end while cuenta.to_i < cantidad.to_i
		Orden.cambiarEstado(id_oc, "finalizada")
		Orden.cambiarCantidad(id_oc, cantidad)
		#Request.deliver_orden(id_oc)
		cuenta
	end
	
	def self.moverBodegaB2B(cantidad, sku, id_oc)
		id_despacho = getIdDespacho
		oc=Request.getOC(id_oc)
		array_productos = Request.getStock(id_despacho, sku, cantidad)
		cuenta=0
		id_cliente=oc.cliente
		almacen_destino=Controlador.getDestino(id_cliente)
		array_productos.each do |p|
			respuesta=Request.moverStockBodega(p, almacen_destino, id_oc, oc.precio_unitario)
			condicion = "Traspaso no realizado debido a falta de espacio"
			#if respuesta['error'].eql? condicion
				#hay que vaciar despacho
			#	break
			#elsif respuesta['error']
			#	break
			#end
			cuenta = cuenta + 1
		end
		Request.deliver_orden(id_oc)
		Orden.cambiarEstado(id_oc, "finalizada")
		Orden.cambiarCantidad(id_oc, cantidad)
		cuenta
	end


	#revisa la forma en que se saca el stock para moverlo a despacho
	def self.revisarFormaDeDespacho(cantidad, sku, id_oc)
		puts "revisarFormaDespacho -> " + cantidad.to_s+" | "+sku+" | "+id_oc
		orden = Request.getOC(id_oc)
		cantidad = 0
		if Almacen.verificar_stock_despacho(cantidad, sku)
			canal="ftp"
			if orden.canal.eql? canal
				"SE METO A FTP"
				cantidad = moverBodegaFTP(cantidad, sku, id_oc)
			end
			canal="b2b"
			if orden.canal.eql? canal
				cantidad = moverBodegaB2B(cantidad, sku, id_oc)
			end
		elsif Almacen.verificar_stock_sin_pulmon(cantidad,sku)
			moverAlmacenDespacho(sku,cantidad)
			canal="b2b"
			if orden.canal.eql? canal
				cantidad = moverBodegaB2B(cantidad, sku, id_oc)
			end
			canal="ftp"
			if orden.canal.eql? canal
				cantidad = moverBodegaFTP(cantidad, sku, id_oc)
			end

					#despachar 
		elsif Almacen.verificar_stock_con_pulmon(cantidad,sku)
			moverAlmacenDespacho(sku,cantidad)
			canal="b2b"
			if orden.canal.eql? canal
				cantidad = moverBodegaB2B(cantidad, sku, id_oc)
			end
			canal="ftp"
			if orden.canal.eql? canal
				cantidad = moverBodegaFTP(cantidad, sku, id_oc)
			end
		else 
						
		end

		puts "Se despacharon -> " + cantidad.to_s

	end
	
end




















