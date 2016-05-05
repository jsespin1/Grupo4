class Producto < ActiveRecord::Base

	belongs_to :sku


	def self.getProductos(productos, cantidad)
		#Arreglo de id de productos que se van a movilizar
		array=[]
		cantidad_almacen = productos.count
		if cantidad_almacen < cantidad
			cantidad = cantidad_almacen
		end
		productos[0..cantidad].each do |prod|
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

	#Retorna




	def self.array_prods
    @array_prods = [
        {sku: "11", costo: 1839, lote: 900, tiempo: 4118},
        {sku: "16", costo: 2292, lote: 1000, tiempo: 4118},
        {sku: "38", costo: 1201, lote: 30, tiempo: 4118},
        {sku: "44", costo: 1091, lote: 50, tiempo: 4118}
        
      ]
  end



end
