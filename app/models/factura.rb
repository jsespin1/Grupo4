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

    #belongs_to :orden

    def self.toObject(response)
        factura = nil
    	r = response
        if r['_id']
            factura = Factura.new(_id: r['_id'], fecha_creacion: r['created_at'], proveedor: r['proveedor'], cliente: r['cliente'], 
            valor_bruto: r['bruto'], iva: r['iva'], valor_total: r['total'], estado_pago: r['pago'], 
            id_oc: r['oc'])
        end
        r.save
	 	factura
    end

    def self.toObject2(response)
        factura = nil
        r = response[0]
        if r['_id']
            factura = Factura.new(_id: r['_id'], fecha_creacion: r['created_at'], proveedor: r['proveedor'], cliente: r['cliente'], 
            valor_bruto: r['bruto'], iva: r['iva'], valor_total: r['total'], estado_pago: r['pago'], 
            id_oc: r['oc'])
        end
        factura
    end




end
