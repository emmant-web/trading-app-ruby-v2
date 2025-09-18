class Transaction < ApplicationRecord
  belongs_to :user

  def self.ransackable_associations(auth_object = nil)
    ["user"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["action", "symbol", "stock_price", "quantity", "created_at"]
  end
end
