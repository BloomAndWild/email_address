################################################################################
# ActiveRecord v5.0 Custom Type
#
# 1) Register your types
#
#    # config/initializers/email_addr.rb
#    ActiveRecord::Type.register(:email_address, EmailAddr::Address)
#    ActiveRecord::Type.register(:canonical_email_address,
#                                EmailAddr::CanonicalEmailAddrType)
#
# 2) Define your email address columns in your model class
#
#    class User < ApplicationRecord
#      attribute :email, :email_address
#      attribute :canonical_email, :canonical_email_address
#
#      def email=(email_address)
#        self[:canonical_email] = email_address
#        self[:email] = email_address
#      end
#    end
#
# 3) Profit!
#
#    user = User.new(email:"Pat.Smith+registrations@gmail.com")
#    user.email           #=> "pat.smith+registrations@gmail.com"
#    user.canonical_email #=> "patsmith@gmail.com"
################################################################################

class EmailAddr::EmailAddrType < ActiveRecord::Type::Value

  # From user input, setter
  def cast(value)
    super(EmailAddr.normal(value))
  end

  # From a database value
  def deserialize(value)
    value && EmailAddr.normal(value)
  end
  #
  # To a database value (string)
  def serialize(value)
    value && EmailAddr.normal(value)
  end
end
