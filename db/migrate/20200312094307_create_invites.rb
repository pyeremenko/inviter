class CreateInvites < ActiveRecord::Migration[6.0]
  def change
    create_table :invites do |t|
      t.string :code
      t.integer :usages

      t.timestamps
    end

    add_index :invites, :code, unique: true
  end
end
