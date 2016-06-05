module Spree
  HomeController.class_eval do

    def falla
      boleta=Boletum.last
      @idboleta=boleta.idboleta
      
    end

    
    def exito

          boleta=Boletum.last
          @despachados = boleta.cantidad
          Thread.new do
            @despachados = Almacen.moverBodegaWEB(boleta.cantidad, boleta.sku, boleta)
          end
          @total = boleta.monto.to_i * 100
          @total = @total.round / 100.0
          @bruto=((@total*1/1.19)*100).round / 100.0
          @iva=@total-@bruto

    end

    def index
      @stock = 0
      @products = Product.all
      @searcher = build_searcher(params.merge(include_images: true))
      @taxonomies = Spree::Taxonomy.includes(root: :children)
    end

  end
end
