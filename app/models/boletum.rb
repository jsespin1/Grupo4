class Boletum < ActiveRecord::Base
    
    def self.crearBoleta(sku, cantidad, direccion, monto)
        
        boleta=Request.crear_boleta(Factura.getIdPropio, direccion, monto)
        puts "Proveedor " + Factura.getIdPropio.to_s 
        puts " Direccion " + direccion.to_s 
        puts " Monto " + monto.to_s 
        puts " ID " + boleta.inspect
        puts " Cantidad " + cantidad.to_s 
        puts " SKU " + sku.to_s
        boletafinal = Boletum.new(proveedor: Factura.getIdPropio, direccion: direccion, monto: monto.to_i, idboleta: boleta['_id'], cantidad: cantidad.to_i, sku: sku) 
        puts "Boleta Final -> " + boletafinal.inspect
    
        boletafinal.save
        puts "Boleta Final 2 -> " + boletafinal.inspect
    end
   
    
end
