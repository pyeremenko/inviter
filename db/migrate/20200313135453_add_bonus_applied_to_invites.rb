class AddBonusAppliedToInvites < ActiveRecord::Migration[6.0]
  def change
    add_column :invites, :bonus_applied, :boolean, default: false
  end
end
