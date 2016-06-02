module Spree

  CheckoutController.class_eval do

    #Modificamos este método de spree para validar Stock contra sistema bodega
    def ensure_sufficient_stock_lines
      product = @order.line_items
      sku = product[0].sku
      stock = Controlador.getStock(sku)
      cantidad_requerida = product[0].quantity.to_i
      puts "REQUERIDO: ->" + cantidad_requerida.to_s + ",  STOCK: " + stock.to_s
      if cantidad_requerida < stock
        flash[:error] = Spree.t(:inventory_error_flash_for_insufficient_quantity)
        redirect_to spree.cart_path
      end
    end
    
  end
end