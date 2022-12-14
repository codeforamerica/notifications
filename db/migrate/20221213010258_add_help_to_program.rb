class AddHelpToProgram < ActiveRecord::Migration[7.0]
  def change
    change_table :programs do |t|
      t.column :help_keywords, :jsonb, null: false, default: []
      t.column :help_response, :jsonb, null: false, default: {}
    end
  end
end
