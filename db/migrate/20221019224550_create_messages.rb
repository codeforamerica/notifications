class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :message_templates do |t|
      t.string :name, null: false, index: { unique: true }
      t.jsonb :body, default: {}

      t.timestamps
    end
  end
end
