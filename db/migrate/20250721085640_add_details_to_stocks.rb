class AddDetailsToStocks < ActiveRecord::Migration[7.2]
  def change
    add_column :stocks, :stock_name, :string
    add_column :stocks, :total_price, :decimal
  end
end
