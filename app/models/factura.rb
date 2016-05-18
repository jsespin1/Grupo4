class Factura < ActiveRecord::Base
	# :_id, :string
    # :fecha_creacion, :datetime
    # :proveedor, :string
    # :cliente, :string
    # :valor_bruto, :integer
    # :iva, :integer
    # :valor_total, :integer
    # :estado_pago, :string
    # :fecha_pago, :datetime
    # :id_oc, :string
    # :motivo_rechazo, :string
    # :motivo_anulacion, :string
    validates :_id, :presence => true, :uniqueness => true
    belongs_to :orden

    def self.toObject(response)
        factura = nil
    	r = response
        if r.to_s.include? '_id'
            factura = Factura.new(_id: r['_id'], fecha_creacion: r['created_at'], proveedor: r['proveedor'], cliente: r['cliente'], 
            valor_bruto: r['bruto'], iva: r['iva'], valor_total: r['total'], estado_pago: r['estado'], 
            id_oc: r['oc'])
            factura.save
        end
	 	factura
    end

    def self.toObject2(response)
        factura = nil
        r = response[0]
        if r.to_s.include? '_id'
            factura = Factura.new(_id: r['_id'], fecha_creacion: r['created_at'], proveedor: r['proveedor'], cliente: r['cliente'], 
            valor_bruto: r['bruto'], iva: r['iva'], valor_total: r['total'], estado_pago: r['estado'], 
            id_oc: r['oc'])
        end
        factura
    end

    def self.verificar_compra(factura)
        #Verificamos si nosotros somos el cliente y el pago está pendiente; la orden está aceptada y si la cantidadDespachada=0
        respuesta = true
        #Cliente-Nosotros y Estado de Factura-Pendiente
        estado = "pendiente"
        if !(factura.cliente == getIdPropio) or !(factura.estado_pago.eql? estado)
            respuesta = false
        end
        #Ahora se obtiene la OC asociada
        oc = Orden.find_by(_id: factura.id_oc)
        if oc != nil
            #Cliente orden nosotros, estado de orden aceptada, cantidadDespachada = 0 y Id factura la misma
            id_cliente = oc.cliente
            estado = "aceptada"
            despachado = oc.cantidad_despachada
            id_factura = oc.id_factura
            if !(id_cliente==getIdPropio) or !(oc.estado.eql? estado) or !(despachado.to_i==0) or !(id_factura.eql? factura._id)
                respuesta = false
            end
        else
            respuesta = false
        end
        respuesta
    end

    def self.verificar_venta(factura)
        #Verificamos si nosotros somos el proveedor y el pago se efectuó; la orden está aceptada y si la cantidadDespachada=0
        respuesta = true
        #Cliente-Nosotros y Estado de Factura-Pagado
        estado = "pagada"
        if !(factura.proveedor == getIdPropio) or !(factura.estado_pago.eql? estado)
            respuesta = false
        end
        #Ahora se obtiene la OC asociada
        oc = Orden.find_by(_id: factura.id_oc)
        if oc != nil
            #Cliente orden nosotros, estado de orden aceptada, cantidadDespachada = 0 y Id factura la misma
            id_proveedor = oc.proveedor
            estado = "aceptada"
            despachado = oc.cantidad_despachada
            id_factura = oc.id_factura
            if !(id_proveedor==getIdPropio) or !(oc.estado.eql? estado) or !(despachado.to_i==0) or !(id_factura.eql? factura._id)
                respuesta = false
            end
        else
            respuesta = false
        end
        respuesta
    end

    def self.existe(factura)
        existe = false
        factura = Factura.find_by(_id: factura._id)
        if !(factura == nil)
            existe = true
        else
            puts "Factura NO existe"
        end
        existe
    end

    def self.saveFactura(factura)
        factura.save
        puts "Se guardo Factura!"
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
