module PhoneNumberMethods
  extend ActiveSupport::Concern

  included do
    def self.clean_phone_numbers(*attributes)
      attributes.each do |attribute|
        before_save do |record|
          if record[attribute].present?
            record[attribute].remove!(/\D/)
            match = /\A1?(\d{10})\z/.match(record[attribute])
            if match
              record[attribute] = match[1]
            end
          end
        end
      end
    end
  end
end
