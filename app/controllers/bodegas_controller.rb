class BodegasController < ApplicationController

	def index 
		@bodegas = JSON.parse(Request.getAlmacenesAll)
		puts "HOLAA" +@bodegas.inspect
	end
	
end
