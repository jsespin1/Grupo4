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
    ActiveMerchant::Billing::Response.new(true, 'success', {}, {})
  end
end