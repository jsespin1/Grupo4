class CreatePromocions < ActiveRecord::Migration
  def change
    create_table :promocions do |t|
      t.string :sku
      t.integer :precio
      t.datetime :inicio
      t.datetime :fin
      t.string :codigo
      t.boolean :publicar

      t.timestamps null: false
    end
  end
end
