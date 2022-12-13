class AddParamsToRecipients < ActiveRecord::Migration[7.0]
  def change
    add_column :recipients, :params, :jsonb, null: true
  end
end
