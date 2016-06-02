module Spree

  CheckoutController.class_eval do
    extend ActiveSupport::Concern
    included do
      class_attribute :gateway_options_class
      self.gateway_options_class = Spree::Payment::GatewayOptions
    end
    #Modificamos este método de spree para validar Stock contra sistema bodega
    def ensure_sufficient_stock_lines
      product = @order.line_items
      sku = product[0].sku
      stock = Controlador.getStock(sku)
      cantidad_requerida = product[0].quantity.to_i
      if cantidad_requerida > stock
        flash[:error] = Spree.t(:inventory_error_flash_for_insufficient_quantity)
        redirect_to spree.cart_path
      end
    end



    #Se agrego para redirigir despues que se elije medio de pago al de sistema
    def update
      if @order.update_from_params(params, permitted_checkout_attributes, request.headers.env)
        @order.temporary_address = !params[:save_user_address]
        unless @order.next
          flash[:error] = @order.errors.full_messages.join("\n")
          redirect_to(checkout_state_path(@order.state)) && return
        end

        if @order.completed?
          product = @order.line_items[0]
          sku = product.sku
          cantidad_requerida = product.quantity.to_i
          monto = product.price.to_i
          direccion = @order.bill_address.address1
          url = Boletum.crearBoleta(sku, cantidad_requerida, direccion, monto)
          redirect_to url
          #@current_order = nil
          flash.notice = Spree.t(:order_processed_successfully)
          flash['order_completed'] = true
          #redirect_to completion_route
        else
          redirect_to checkout_state_path(@order.state)
        end
      else
        render :edit
      end
    end

    def before_payment
      gateway_options_class = Spree::Payment::GatewayOptions
      puts :amount.inspect
      if @order.checkout_steps.include? "delivery"
        packages = @order.shipments.map(&:to_package)
        @differentiator = Spree::Stock::Differentiator.new(@order, packages)
        @differentiator.missing.each do |variant, quantity|
          @order.contents.remove(variant, quantity)
        end
      end

      if try_spree_current_user && try_spree_current_user.respond_to?(:payment_sources)
        @payment_sources = try_spree_current_user.payment_sources
      end
    end
    
  end
end