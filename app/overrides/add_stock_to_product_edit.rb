

Deface::Override.new(:virtual_path => 'spree/products/show',
  :name => 'add_stock_to_product_edit',
  :insert_after => "div#main-image",
  :partial => "shared/stock_show")

Deface::Override.new(:virtual_path => 'spree/shared/_products',
  :name => 'add_stock_to_product_edit',
  :insert_after => "div.panel-body",
  :partial => "shared/stock_index")
