module Spree
  HomeController.class_eval do
    def inicio
      puts "INICIOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO"
      @products = Product.all
      puts "SE LLAMO CREAR BOLETA 1"
		  crearBoleta(38, 2, "mi casa",  1.513*1.19*2)
    end

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
          #puts "CANTIDAD DESPACHADA ->" + despachados
          @total=(boleta.monto *100).round / 100.0
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