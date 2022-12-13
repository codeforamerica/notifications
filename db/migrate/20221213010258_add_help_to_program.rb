class AddHelpToProgram < ActiveRecord::Migration[7.0]
  def change
    change_table :programs do |t|
      t.column :help_keywords, :jsonb
      t.column :help_response, :jsonb, default: {}
    end
  end
end
