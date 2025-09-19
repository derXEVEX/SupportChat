class AddCategoryToSupportRequests < ActiveRecord::Migration[8.0]
  def change
    add_reference :support_requests, :category, null: false, foreign_key: true
  end
end
