class Boletum < ActiveRecord::Base
    
    def self.crearBoleta(sku, cantidad, direccion, monto)
        monto = monto*1.19
        boleta=Request.crear_boleta(Factura.getIdPropio, direccion, monto)
        boletafinal = Boletum.new(proveedor: Factura.getIdPropio, direccion: direccion, monto: monto.to_i, idboleta: boleta['_id'], cantidad: cantidad.to_i, sku: sku) 
        boletafinal.save
        boletaid = boleta['_id']
        url = getUrl(boletaid)
        url
    end

    def self.getUrl(boletaId)
        if Rails.env == 'development'
            url = "http://integracion-2016-dev.herokuapp.com/web/pagoenlinea?callbackUrl=https%3A%2F%2Fgrupo4v2-fgarri.c9users.io%2Fexito&cancelUrl=https%3A%2F%2Fgrupo4v2-fgarri.c9users.io%2Ffalla&boletaId="+boletaId
        else
            #RECORDAR CAMBIARLO A PROD
            url = "http://integracion-2016-prod.herokuapp.com/web/pagoenlinea?callbackUrl=http%3A%2F%2Fintegra4.ing.puc.cl%2Fexito&cancelUrl=http%3A%2F%2Fwww.emol.com&boletaId="+boletaId
        end
        url
    end
    
end
