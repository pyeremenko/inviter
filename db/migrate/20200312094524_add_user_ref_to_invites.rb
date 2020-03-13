class AddUserRefToInvites < ActiveRecord::Migration[6.0]
  def change
    add_reference :invites, :user, foreign_key: true, unique: true
  end
end
