class Orden < ActiveRecord::Base

	#has_one :factura

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
	 		fecha_entrega: r['fechaEntrega'], estado: r['estado'])
	 	orden.save
	 	orden
    end


    def self.verificar_oc(oc)
    	respuesta = true
    	if !(oc.sku <=> "11" || oc.sku <=> "16" || oc.sku <=> "38" || oc.sku <=> "44")
    			respuesta = false
    	end
    	if !(oc.estado <=> "creada")
    			respuesta = false
    	end
    	respuesta
    end


end
