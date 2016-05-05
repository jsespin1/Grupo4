class CreateFinanzas < ActiveRecord::Migration
  def change
    create_table :finanzas do |t|

      t.timestamps null: false
    end
  end
end
