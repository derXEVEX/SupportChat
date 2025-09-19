class CreateSupportRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :support_requests do |t|
      t.string :title
      t.string :status
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
