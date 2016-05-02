class CreateControladors < ActiveRecord::Migration
  def change
    create_table :controladors do |t|

      t.timestamps null: false
    end
  end
end
