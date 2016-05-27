module Spree
  HomeController.class_eval do
    def inicio
      @products = Product.all
    end
    def index
      @stock = 0
      @products = Product.all
      @searcher = build_searcher(params.merge(include_images: true))
      @taxonomies = Spree::Taxonomy.includes(root: :children)
    end
  end
end
