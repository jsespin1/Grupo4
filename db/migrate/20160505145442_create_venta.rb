class CreateVenta < ActiveRecord::Migration
  def change
    create_table :venta do |t|

      t.timestamps null: false
    end
  end
end
