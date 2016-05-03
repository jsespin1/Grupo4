class Controlador < ActiveRecord::Base

	#A este metodo le llega un id de orden de compra desde pedidos
	def self.procesar_oc(id)
		#primero se crea, con el id, la orden
		@oc = Request.getOC(id)[0]
		#luego se debe revisar el stock, sumando todos los almacenes
		sku = @oc['sku'].to_i
		cantidadDespachada = @oc['cantidadDespachada'].to_i
		cantidad = @oc['cantidad'].to_i
		total = Almacen.getSkusTotal(sku).to_i

	end


	def self.getStock(id)
		#se debe revisar el stock, sumando todos los almacenes
		total = Almacen.getSkusTotal(id).to_i
	end

	


end
