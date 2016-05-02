class CreateSkus < ActiveRecord::Migration
  def change
    create_table :skus do |t|
      t.string :_id

      t.timestamps null: false
    end
  end
end
