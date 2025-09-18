class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.string :action
      t.string :symbol
      t.integer :quantity
      t.float :stock_price
      t.float :total_price
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
