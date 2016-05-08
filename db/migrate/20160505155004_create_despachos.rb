class CreateDespachos < ActiveRecord::Migration
  def change
    create_table :despachos do |t|
      t.string :id_oc
      t.string :id_factura
      t.string :id_trx
      t.integer :cantidad
      t.integer :cantidad_despachada

      t.timestamps null: false
    end
  end
end
