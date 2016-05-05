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
		#Primero se obtienen todos los skus
		id = "0"
		@almacenes = Request.getAlmacenesAll
		@almacenes.each do |a|
			if a.despacho
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
				


  
  	def self.revisarAlmacenRecepcion()
  		id_almacen = getAlmacenRecepcion
  		puts "id almacen -> " + id_almacen
  		arreglo_skus = Request.getSKUs(id_almacen.to_s)
  		puts "arreglo_skus " + arreglo_skus.inspect
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
	
end