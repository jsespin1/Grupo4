class Orden < ActiveRecord::Base

	def self.getOrdenes(oc)
		#ordenes = []
		#puts "Todo -> " + oc.inspect
		#oc.each do |e|
			#o = Orden.new(:_id => e['_id'...)
			#puts "ID -> " + e['_id']
		#end	
	 end

	 def self.toObject(response)
	 	r = response[0]
	 	orden = Orden.new(_id: r['_id'], fecha_creacion: r['created_at'], canal: r['canal'], proveedor: r['proveedor'], cliente: r['cliente'], 
	 		sku: r['sku'], cantidad: r['cantidad'], cantidad_despachada: r['cantidadDespachada'], precio_unitario: r['precioUnitario'], 
	 		fecha_entrega: r['fechaEntrega'], fecha_despacho: r['fechaDespachos'], estado: r['estado'])
     end
end
