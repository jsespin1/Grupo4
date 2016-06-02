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
        boletaid=boleta['_id']
        url="http://integracion-2016-dev.herokuapp.com/web/pagoenlinea?callbackUrl=localhost%3A3000&cancelUrl=http%3A%2F%2Fwww.emol.com&boletaId="+boletaid
        #redirect_to URI.parse(url)
    end
   
    
end
