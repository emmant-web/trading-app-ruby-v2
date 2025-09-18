class Stock < ApplicationRecord
  belongs_to :user

  def self.ransackable_associations(auth_object = nil)
    ["user"]
  end


  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "shares", "stock_name", "symbol", "total_price", "updated_at", "user_id"]
  end
  
end
