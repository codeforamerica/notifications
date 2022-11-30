class CreatePrograms < ActiveRecord::Migration[7.0]
  def change
    create_table :programs do |t|
      t.string :name, null: false
      t.jsonb :opt_in_keywords, null: false
      t.jsonb :opt_out_keywords, null: false
      t.jsonb :opt_in_response, null: false, default: {}
      t.jsonb :opt_out_response, null: false, default: {}
      t.timestamps
    end

    remove_column :recipients, :program, :string

    add_reference :message_batches, :program
    add_reference :consent_changes, :program
  end
end
