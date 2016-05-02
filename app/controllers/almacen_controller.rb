class AlmacenController < ApplicationController


	def index 
		@almacenes = Request.getAlmacenesAll
		Request.create_orden('b2b', 4, '38', '571262b8a980ba030058ab52', '571262b8a980ba030058ab52', 1513, 3563209336999, 'jpp' )
		@oc = Request.getOC("57127d2e8a9e6506000b998a")
		#Ftp.showls
	end

	def show
		@almacen = params[:almacen]
		@skus = Request.getSKUs(params[:almacen]['_id'])
		#Obtenemos
		#productos = Request.getStock(params[:almacen]['_id'], s._id)

	end

end
