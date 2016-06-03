module Spree
  HomeController.class_eval do


    
    def exito
      
          boleta=Boletum.last
          @despachados = boleta.cantidad
          Thread.new do
            @despachados = Almacen.moverBodegaWEB(boleta.cantidad, boleta.sku, boleta)
          end

          
    end
    
    def index
      @stock = 0
      @products = Product.all
      @searcher = build_searcher(params.merge(include_images: true))
      @taxonomies = Spree::Taxonomy.includes(root: :children)
    end

  end
end