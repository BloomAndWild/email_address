
module EmailAddr

  require "email_addr/config"
  require "email_addr/exchanger"
  require "email_addr/host"
  require "email_addr/local"
  require "email_addr/address"
  require "email_addr/version"
  require "email_addr/active_record_validator" if defined?(ActiveModel)
  if defined?(ActiveRecord) && ::ActiveRecord::VERSION::MAJOR >= 5
    require "email_addr/email_address_type"
    require "email_addr/canonical_email_address_type"
  end

  # @!method self.valid?(options={})
  #   Proxy method to {EmailAddr::Address#valid?}
  # @!method self.error
  #   Proxy method to {EmailAddr::Address#error}
  # @!method self.normal
  #   Proxy method to {EmailAddr::Address#normal}
  # @!method self.redact(digest=:sha1)
  #   Proxy method to {EmailAddr::Address#redact}
  # @!method self.munge
  #   Proxy method to {EmailAddr::Address#munge}
  # @!method self.canonical
  #   Proxy method to {EmailAddr::Address#canonical}
  # @!method self.reference
  #   Proxy method to {EmailAddr::Address#reference}
  class << self
    (%i[valid? error normal redact munge canonical reference] &
     EmailAddr::Address.public_instance_methods
    ).each do |proxy_method|
      define_method(proxy_method) do |*args, &block|
        EmailAddr::Address.new(*args).public_send(proxy_method, &block)
      end
    end
  end


  # Creates an instance of this email address.
  # This is a short-cut to Email::Address::Address.new
  def self.new(email_address, config={})
    EmailAddr::Address.new(email_address, config)
  end

  # Given an email address, this returns true if the email validates, false otherwise
  def self.valid?(email_address, config={})
    self.new(email_address, config).valid?
  end

  # Given an email address, this returns nil if the email validates,
  # or a string with a small error message otherwise
  def self.error(email_address, config={})
    self.new(email_address, config).error
  end

  # Shortcut to normalize the given email address in the given format
  def self.normal(email_address, config={})
    EmailAddr::Address.new(email_address, config).to_s
  end

  # Shortcut to normalize the given email address
  def self.redact(email_address, config={})
    EmailAddr::Address.new(email_address, config).redact
  end

  # Shortcut to munge the given email address for web publishing
  # returns ma_____@do_____.com
  def self.munge(email_address, config={})
    EmailAddr::Address.new(email_address, config).munge
  end

  def self.new_redacted(email_address, config={})
    EmailAddr::Address.new(EmailAddr::Address.new(email_address, config).redact)
  end

  # Returns the Canonical form of the email address. This form is what should
  # be considered unique for an email account, lower case, and no address tags.
  def self.canonical(email_address, config={})
    EmailAddr::Address.new(email_address, config).canonical
  end

  def self.new_canonical(email_address, config={})
    EmailAddr::Address.new(EmailAddr::Address.new(email_address, config).canonical, config)
  end

  # Returns the Reference form of the email address, defined as the MD5
  # digest of the Canonical form.
  def self.reference(email_address, config={})
    EmailAddr::Address.new(email_address, config).reference
  end

  # Does the email address match any of the given rules
  def self.matches?(email_address, rules, config={})
    EmailAddr::Address.new(email_address, config).matches?(rules)
  end
end
