class CreateSaldos < ActiveRecord::Migration
  def change
    create_table :saldos do |t|
      t.string :_id
      t.string :cuenta
      t.float :monto

      t.timestamps null: false
    end
  end
end
