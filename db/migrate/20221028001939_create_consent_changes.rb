class CreateConsentChanges < ActiveRecord::Migration[7.0]
  def change
    create_table :consent_changes do |t|
      t.boolean :new_consent
      t.string :change_source, null: false
      t.references :sms_message, foreign_key: true

      t.timestamps
    end
  end
end
