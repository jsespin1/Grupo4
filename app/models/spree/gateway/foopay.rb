class Spree::Gateway::Foopay < Spree::Gateway
  def provider_class
    Spree::Gateway::Foopay
  end
  def payment_source_class
    Spree::CreditCard
  end

  def method_type
    'foopay'
  end

  def purchase(amount, transaction_details, options = {})
    #Aca Llamamos al método de pago INTEGRACION
    numero_orden = options[:order_id]
    numero_orden = numero_orden.split("-")[0]
    orden = Spree::Order.find_by_number(numero_orden)
    product = orden.line_items[0]
    sku = product.sku
    cantidad_requerida = product.quantity.to_i
    price = product.price.to_i
    address = options[:billing_address][:address1]
    Boletum.crearBoleta(sku, cantidad_requerida, address, price)
    ActiveMerchant::Billing::Response.new(true, 'success', {}, {})
  end
end