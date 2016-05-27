module Spree
  HomeController.class_eval do
    def inicio
      @products = Product.all
    end
  end
end
