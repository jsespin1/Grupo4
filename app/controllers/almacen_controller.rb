class AlmacenController < ApplicationController


	def index 
		@almacenes = Request.getAlmacenesAll
	end

	def show
		@almacen = params[:almacen]
		@skus = Request.getSKUs(params[:almacen]['_id'])
	end

end
