module Spree
  HomeController.class_eval do
    def inicio
      @products = Product.all
    end
    def exito
      boleta=Boletum.last
      despachados=Almacen.moverBodegaWEB(boleta.cantidad, boleta.sku, boleta)
    end
  end
end
