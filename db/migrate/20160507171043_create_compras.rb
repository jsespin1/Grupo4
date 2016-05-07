class CreateCompras < ActiveRecord::Migration
  def change
    create_table :compras do |t|

      t.timestamps null: false
    end
  end
end
