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
		end
		puts "Arreglo Stock -> " + array.inspect
	end

end
