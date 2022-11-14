class PhoneNumberValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.remove(/\D/).match /\A1?\d{10}\z/
      record.errors.add attribute, "#{value} is not a valid phone number"
    end
  end
end
