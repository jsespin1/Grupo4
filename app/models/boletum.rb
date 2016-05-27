class Boletum < ActiveRecord::Base
    
    def self.crearBoleta(sku, cantidad, direccion, monto)
        
        boleta=Request.crear_boleta(Factura.getIdPropio, direccion, monto)
        boletafinal = Boletum.new(idboleta: boleta['_id'], proveedor: Factura.getIdPropio, direccion: direccion, monto: monto, cantidad: cantidad, sku: sku) 
        boletafinal.save
    end
    
    
end
