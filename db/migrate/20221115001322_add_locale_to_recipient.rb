class AddLocaleToRecipient < ActiveRecord::Migration[7.0]

  def up
    create_enum :locale, %w(en es)

    change_table :recipients do |t|
      t.enum :preferred_language, enum_type: :locale, null: true
    end
  end

  def down
    remove_column :recipients, :preferred_language

    execute <<-SQL
    DROP TYPE locale;
    SQL
  end

end
