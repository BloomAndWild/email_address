require_relative '../test_helper'

class TestConfig < MiniTest::Test
  def test_setting
    assert_equal :mx,  EmailAddr::Config.setting(:dns_lookup)
    assert_equal :off, EmailAddr::Config.setting(:dns_lookup, :off)
    assert_equal :off, EmailAddr::Config.setting(:dns_lookup)
    EmailAddr::Config.setting(:dns_lookup, :mx)
  end

  def test_configure
    assert_equal :mx,   EmailAddr::Config.setting(:dns_lookup)
    assert_equal true,  EmailAddr::Config.setting(:local_downcase)
    EmailAddr::Config.configure(local_downcase:false, dns_lookup: :off)
    assert_equal :off,  EmailAddr::Config.setting(:dns_lookup)
    assert_equal false, EmailAddr::Config.setting(:local_downcase)
    EmailAddr::Config.configure(local_downcase:true, dns_lookup: :mx)
  end

  def test_provider
    assert_equal nil, EmailAddr::Config.provider(:github)
    EmailAddr::Config.provider(:github, host_match: %w(github.com), local_format: :standard)
    assert_equal :standard, EmailAddr::Config.provider(:github)[:local_format]
    assert_equal :github, EmailAddr::Host.new("github.com").provider
    EmailAddr::Config.providers.delete(:github)
    assert_equal nil, EmailAddr::Config.provider(:github)
  end
end
