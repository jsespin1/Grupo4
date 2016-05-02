class CreateFtps < ActiveRecord::Migration
  def change
    create_table :ftps do |t|

      t.timestamps null: false
    end
  end
end
