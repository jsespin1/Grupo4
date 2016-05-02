class CreateAlmacens < ActiveRecord::Migration
  def change
    create_table :almacens do |t|
      t.string :_id
      t.integer :grupo
      t.boolean :pulmon
      t.boolean :despacho
      t.boolean :recepcion
      t.integer :totalSpace
      t.integer :usedSpace
      t.integer :v

      t.timestamps null: false
    end
  end
end
