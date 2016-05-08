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
    	arreglo = ["11", "16", "38", "44"]
    	if !((oc.sku.eql? arreglo(0).to_s) || (oc.sku.eql? arreglo(1).to_s) || (oc.sku.eql? arreglo(2).to_s) || (oc.sku.eql? arreglo(3).to_s))
    			respuesta = false
    	end
    	auxiliar = "creada"
    	if !(oc.estado.eql? auxiliar)
    			respuesta = false
    	end
    	respuesta
    end

    def self.cambiarEstado(oc_id, estado)
    	orden = Orden.find_by(_id: oc_id)
		orden.update_attributes(:estado => estado)
    end

    def self.cambiarCantidad(oc_id, despachadas)
    	orden = Orden.find_by(_id: oc_id)
		orden.update_attributes(:cantidad_despachada => despachadas)
    end


end
