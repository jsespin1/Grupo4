class AddCantidadSkuToSku < ActiveRecord::Migration
  def change
    add_column :skus, :cantidad, :integer
  end
end
