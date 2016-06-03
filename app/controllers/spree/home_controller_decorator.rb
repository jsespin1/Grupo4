module Spree
  HomeController.class_eval do
    def inicio
      puts "INICIOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO"
      @products = Product.all
      puts "SE LLAMO CREAR BOLETA 1"
		  crearBoleta(38, 2, "mi casa",  1.513*1.19*2)
    end

    def exito

          boleta=Boletum.last
          puts "BOLETA ->"+boleta.inspect
          puts "STOCK PRE DESPACHO " + Almacen.getSkusTotal("38").to_s
          @despachados=Almacen.moverBodegaWEB(boleta.cantidad, boleta.sku, boleta)
          puts "STOCK POST DESPACHO " + Almacen.getSkusTotal("38").to_s
          #puts "CANTIDAD DESPACHADA ->" + despachados
          @total=boleta.monto
          @bruto=@total*1/1.19
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
