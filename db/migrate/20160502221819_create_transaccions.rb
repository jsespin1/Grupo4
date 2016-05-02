class CreateTransaccions < ActiveRecord::Migration
  def change
    create_table :transaccions do |t|
      t.string :_id
      t.datetime :fecha_creacion
      t.string :cuenta_origen
      t.string :cuenta_destino
      t.float :monto

      t.timestamps null: false
    end
  end
end
