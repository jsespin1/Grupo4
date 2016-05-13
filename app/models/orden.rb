class Orden < ActiveRecord::Base

    validates :_id, :presence => true, :uniqueness => true



	def self.toObject(response)
	 	r = response[0]
        if r.to_s.include? '_id'
            orden = Orden.new(_id: r['_id'], fecha_creacion: r['created_at'], canal: r['canal'], proveedor: r['proveedor'], cliente: r['cliente'], 
            sku: r['sku'], cantidad: r['cantidad'], cantidad_despachada: r['cantidadDespachada'], precio_unitario: r['precioUnitario'], 
            fecha_entrega: r['fechaEntrega'], estado: r['estado'])
        else
            orden = nil
        end
	 	orden
    end


    def self.verificar_oc(oc)
    	respuesta = true
    	arreglo = ["11", "16", "38", "44"]
        if oc == nil
            respuesta = false
        else
            #Si no despachamos el tipo de producto
            if !((oc.sku.eql? arreglo[0].to_s) or (oc.sku.eql? arreglo[1].to_s) or (oc.sku.eql? arreglo[2].to_s) or (oc.sku.eql? arreglo[3].to_s))
                puts "NO se despacha este tipo de productos!!"
                respuesta = false
            end
            auxiliar = "creada"
            #Si la OC tiene un estado distinto a creada O nosotros no somos el proveedor
            if !(oc.estado.eql? auxiliar) or (oc.proveedor != getIdPropio)
                puts "Esta OC no esta creada o no somos el proveedor correcto!!!"
                respuesta = false
            end
        end
    	respuesta
    end

    def self.existe(oc)
        existe = false
        orden = Orden.find_by(_id: oc._id)
        if !(orden == nil)
            existe = true
        else
            puts "Orden NO existe"
        end
        existe
    end

    def self.saveOc(oc)
        oc.save
        puts "Se guardo Orden!"
    end

    def self.cambiarEstado(oc_id, estado)
    	orden = Orden.find_by(_id: oc_id)
		orden.update_attributes(:estado => estado)
    end

    def self.cambiarCantidad(oc_id, despachadas)
    	orden = Orden.find_by(_id: oc_id)
        total = orden.cantidad_despachada.to_i + despachadas.to_i
		orden.update_attributes(:cantidad_despachada => total)
    end

    def self.getIdPropio
        #571262b8a980ba030058ab52
        id = ""
        if Rails.env == 'development'
            id = "571262b8a980ba030058ab52"
        else
            id = "572aac69bdb6d403005fb045"
        end
        id
    end


end
