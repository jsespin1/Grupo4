class Boletum < ActiveRecord::Base
    
    def self.crearBoleta(sku, cantidad, direccion, monto)
        
        boleta=Request.crear_boleta(Factura.getIdPropio, direccion, monto)
        boletafinal = Boletum.new(proveedor: Factura.getIdPropio, direccion: direccion, monto: monto.to_i, idboleta: boleta['_id'], cantidad: cantidad.to_i, sku: sku) 
        boletafinal.save
        boletaid = boleta['_id']
        url = getUrl(boletaid)
        url
    end

    def getUrl(boletaId)
        if Rails.env == 'development'
            url = "http://integracion-2016-dev.herokuapp.com/web/pagoenlinea?callbackUrl=localhost%3A3000&cancelUrl=http%3A%2F%2Fwww.emol.com&boletaId="+boletaid
        else
            #RECORDAR CAMBIARLO A PROD
            url = "http://integracion-2016-dev.herokuapp.com/web/pagoenlinea?callbackUrl=integra4.ing.puc.cl&cancelUrl=http%3A%2F%2Fwww.emol.com&boletaId="+boletaid
        end
        url
    end
    
end
