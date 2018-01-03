#encoding: utf-8
require_relative '../test_helper'

class TestAddress < Minitest::Test
  def test_address
    a = EmailAddr.new("User+tag@example.com")
    assert_equal "user+tag", a.local.to_s
    assert_equal "example.com", a.host.to_s
    assert_equal "us*****@ex*****", a.munge
    assert_equal :default, a.provider
  end

  # LOCAL
  def test_local
    a = EmailAddr.new("User+tag@example.com")
    assert_equal "user", a.mailbox
    assert_equal "user+tag", a.left
    assert_equal "tag", a.tag
  end

  # HOST
  def test_host
    a = EmailAddr.new("User+tag@example.com")
    assert_equal "example.com", a.hostname
    #assert_equal :default, a.provider
  end

  # ADDRESS
  def test_forms
    a = EmailAddr.new("User+tag@example.com")
    assert_equal "user+tag@example.com", a.to_s
    assert_equal "user@example.com", a.canonical
    assert_equal "{63a710569261a24b3766275b7000ce8d7b32e2f7}@example.com", a.redact
    assert_equal "{b58996c504c5638798eb6b511e6f49af}@example.com", a.redact(:md5)
    assert_equal "b58996c504c5638798eb6b511e6f49af", a.reference
  end

  # COMPARISON & MATCHING
  def test_compare
    a = ("User+tag@example.com")
    #e = EmailAddr.new("user@example.com")
    n = EmailAddr.new(a)
    c = EmailAddr.new_canonical(a)
    #r = EmailAddr.new_redacted(a)
    assert_equal true, n == "user+tag@example.com"
    assert_equal true, n >  "b@example.com"
    assert_equal true, n.same_as?(c)
    assert_equal true, n.same_as?(a)
  end

  def test_matches
    a = EmailAddr.new("User+tag@gmail.com")
    assert_equal false,  a.matches?('mail.com')
    assert_equal 'google',  a.matches?('google')
    assert_equal 'user+tag@',  a.matches?('user+tag@')
    assert_equal 'user*@gmail*',  a.matches?('user*@gmail*')
  end

  def test_empty_address
    a = EmailAddr.new("")
    assert_equal "{da39a3ee5e6b4b0d3255bfef95601890afd80709}", a.redact
    assert_equal "", a.to_s
    assert_equal "", a.canonical
    assert_equal "d41d8cd98f00b204e9800998ecf8427e", a.reference
  end

  # VALIDATION
  def test_valid
    assert EmailAddr.valid?("User+tag@example.com", host_validation: :a), "valid 1"
    assert ! EmailAddr.valid?("User%tag@example.com", host_validation: :a), "valid 2"
    assert EmailAddr.new("ɹᴉɐℲuǝll∀@ɹᴉɐℲuǝll∀.ws", local_encoding: :uncode, host_validation: :syntax ), "valid unicode"
  end

  def test_localhost
    e = EmailAddr.new("User+tag.gmail.ws") # No domain means localhost
    assert_equal '', e.hostname
    assert_equal false, e.valid? # localhost not allowed by default
    assert_equal EmailAddr.error("user1"), :domain_invalid
    assert_equal EmailAddr.error("user1", host_local:true),nil # :domain_does_not_accept_email
    assert_equal EmailAddr.error("user1@localhost", host_local:true), nil #:domain_does_not_accept_email
    assert_equal EmailAddr.error("user2@localhost", host_local:true, dns_lookup: :off, host_validation: :syntax), nil
  end

  def test_regexen
    assert "First.Last+TAG@example.com".match(EmailAddr::Address::CONVENTIONAL_REGEX)
    assert "First.Last+TAG@example.com".match(EmailAddr::Address::STANDARD_REGEX)
    assert_equal nil, "First.Last+TAGexample.com".match(EmailAddr::Address::STANDARD_REGEX)
    assert_equal nil, "First#Last+TAGexample.com".match(EmailAddr::Address::CONVENTIONAL_REGEX)
    assert "aasdf-34-.z@example.com".match(EmailAddr::Address::RELAXED_REGEX)
  end

  # Quick Regression tests for addresses that should have been valid (but fixed)
  def test_issues
    assert true, EmailAddr.valid?('test@jiff.com', dns_lookup: :mx) # #7
    assert true, EmailAddr.valid?("w.-asdf-_@hotmail.com") # #8
    assert true, EmailAddr.valid?("first_last@hotmail.com") # #8
  end

  def test_issue9
    assert ! EmailAddr.valid?('example.user@foo.')
    assert ! EmailAddr.valid?('ogog@sss.c')
    assert ! EmailAddr.valid?('example.user@foo.com/')
  end

end
