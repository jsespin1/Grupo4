class Producto < ActiveRecord::Base

	belongs_to :sku


	def self.getProductos(productos, cantidad)
		#Arreglo de id de productos que se van a movilizar
		array=[]
		cantidad_almacen = productos.count
		if cantidad_almacen < cantidad
			cantidad = cantidad_almacen
		end
		productos[0..cantidad-1].each do |prod|
			array.push(prod['_id'])
		end
		array
	end

	#True o False si es MP producida por FABRICA
	def self.esMPPropia(sku)
		es = false
		if sku.to_i == 38 || sku.to_i == 44
			es = true
		end
		es
	end

#----------------INFO Productos-----------------#


	def self.get_costo(sku)
		costo = 0
		#Arreglo
		info = info_prods
		info.each do |i|
			if i['sku']==sku
				costo = i['costo']
			end
		end
		costo
	end
	def self.get_lote(sku)
		lote = 0
		info = info_prods
		info.each do |i|
			if i['sku']==sku
				lote = i['lote']
			end
		end
		lote
	end
	def self.get_tiempo(sku)
		tiempo = 0
		info = info_prods
		info.each do |i|
			if i['sku']==sku
				tiempo = i['tiempo']
			end
		end
		tiempo
	end

#------------------- INFO de Producción -----------------#

	#Entrega arreglo[] con las MP requeridas para producir y su cantidad
	def self.get_MP(sku)
		#Hash => arreglo de arreglos
		info = info_produccion
		info_requerida = info[sku] 
	end


#----------------INFO de Niveles de Abastecimiento-----------------#

	#Retorna el stock mínimo requerido para un sku
	def self.get_minimo(sku)
		minimo = 99999
		info = niveles
		info_niveles = niveles[sku]
		if info_niveles != nil
			minimo = info_niveles[0]
		end
		minimo
	end

	#Retorna el stock mínimo requerido para un sku
	def self.get_maximo(sku)
		maximo = -1
		info = niveles
		info_niveles = niveles[sku]
		if info_niveles != nil
			maximo = info_niveles[1]
		end
		maximo
	end


#------------------------ DATOS ---------------------------#

	def self.info_prods
		#Arreglo
	     info_prods = [
	        {sku: "11", costo: 1839, lote: 900, tiempo: 4118},
	        {sku: "16", costo: 2292, lote: 1000, tiempo: 4118},
	        {sku: "38", costo: 1201, lote: 30, tiempo: 4118},
	        {sku: "44", costo: 1091, lote: 50, tiempo: 4118}
	        
	      ]
	 end

    def self.info_produccion
  	  #Hash con arreglo de arreglos, cada arreglo[1, 2] representa el sku de la MP y cantidad necesaria
  	  #Margarina: 828 d aceite maravilla | Pasta de trigo: 330 d harina, 313 d sal y 383 d huevo
      info_produccion = { "11"=>[["4", 828]], "16"=>[["23", 330], ["26", 313], ["2", 383]] }     
    end

    def self.niveles
    	#Hash apuntando a arreglo[1,2] con inventario mínimo e inventario máximo
  	  #Stocks minimos para cada unos de las MP y PP, incluyendo MP no producidas por nosotros
      niveles = { "11"=> [], "16"=> [], "38" => [], "44" => [],
                           "4" => [], "23" => [], "26" => [], "2" => []  }   

    end




end
