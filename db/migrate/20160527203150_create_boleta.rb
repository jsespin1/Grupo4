class CreateBoleta < ActiveRecord::Migration
  def change
    create_table :boleta do |t|
      t.string :proveedor
      t.string :direccion
      t.integer :monto
      t.string :idboleta
      t.integer :cantidad
      t.string :sku

      t.timestamps null: false
    end
  end
end
