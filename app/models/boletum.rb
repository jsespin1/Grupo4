class Boletum < ActiveRecord::Base
    
    def self.crearBoleta(sku, cantidad, direccion, monto)    
        boleta=Request.crear_boleta(Factura.getIdPropio, direccion, monto)
        boletafinal = Boletum.new(proveedor: Factura.getIdPropio, direccion: direccion, monto: monto.to_i, idboleta: boleta['_id'], cantidad: cantidad.to_i, sku: sku) 
        boletafinal.save
        boletaid = boleta['_id']
        url = getUrl(boletaid)
        url
    end

    def self.getUrl(boletaId)
        if Rails.env == 'development'
            url = "http://integracion-2016-dev.herokuapp.com/web/pagoenlinea?callbackUrl=localhost%3A3000%2Fexito&cancelUrl=http%3A%2F%2Fwww.emol.com&boletaId="+boletaId
        else
            #RECORDAR CAMBIARLO A PROD
            url = "http://integracion-2016-dev.herokuapp.com/web/pagoenlinea?callbackUrl=integra4.ing.puc.cl&cancelUrl=http%3A%2F%2Fwww.emol.com&boletaId="+boletaId
        end
        url
    end
    
end
