class CreateAbastecers < ActiveRecord::Migration
  def change
    create_table :abastecers do |t|

      t.timestamps null: false
    end
  end
end
