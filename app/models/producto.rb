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
end
