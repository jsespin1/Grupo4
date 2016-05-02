class AlmacenController < ApplicationController


	def index 
		@almacenes = Request.getAlmacenesAll
	end

	def show
		@almacen = params[:almacen]
		@skus = Request.getSKUs(params[:almacen]['_id'])
		array = []
		@skus.each do |s|
			array.push(Request.getStock(params[:almacen]['_id'], s._id))
		Request.create_orden('b2b', 4, '38', '571262b8a980ba030058ab52', '571262b8a980ba030058ab52', 1513, 1463209336, 'jpp' )
		end

		puts "Arreglo Stock -> " + array.inspect
	end

end
