class CreateConsentChanges < ActiveRecord::Migration[7.0]
  def change
    create_table :consent_changes do |t|
      t.boolean :new_consent
      t.string :change_source
      t.references :sms_messages, foreign_key: true

      t.timestamps
    end
  end
end
