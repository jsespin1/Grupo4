class CreateOrdens < ActiveRecord::Migration
  def change
    create_table :ordens do |t|
      t.string :_id
      t.datetime :fecha_creacion
      t.string :canal
      t.string :proveedor
      t.string :cliente
      t.string :sku
      t.integer :cantidad
      t.integer :cantidad_despachada
      t.integer :precio_unitario
      t.datetime :fecha_entrega
      t.datetime :fecha_despacho
      t.string :estado
      t.string :motivo_rechazo
      t.string :motivo_anulacion
      t.string :notas
      t.string :id_factura

      t.timestamps null: false
    end
  end
end
