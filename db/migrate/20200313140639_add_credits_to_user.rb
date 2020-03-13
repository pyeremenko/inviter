class AddCreditsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :credits, :decimal, precision: 10, scale: 2, default: 0
  end
end
