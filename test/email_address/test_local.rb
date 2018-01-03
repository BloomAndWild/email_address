# encoding: UTF-8
require_relative '../test_helper'

class TestLocal < MiniTest::Test

  def test_valid_standard
    [ # Via https://en.wikipedia.org/wiki/Email_address
      %Q{prettyandsimple},
      %Q{very.common},
      %Q{disposable.style.email.with+symbol},
      %Q{other.email-with-dash},
      %Q{"much.more unusual"},
      %Q{"(comment)very.unusual.@.unusual.com"},
      %Q{#!$%&'*+-/=?^_`{}|~},
      %Q{" "},
      %Q{"very.(),:;<>[]\\".VERY.\\"very@\\ \\"very\\".unusual"},
      %Q{"()<>[]:,;@\\\"!#$%&'*+-/=?^_`{}| ~.a"},
      %Q{token." ".token},
      %Q{abc."defghi".xyz},
    ].each do |local|
      assert EmailAddr::Local.new(local, local_fix: false).standard?, local
    end
  end

  def test_invalid_standard
    [ # Via https://en.wikipedia.org/wiki/Email_address
      %Q{A@b@c},
      %Q{a"b(c)d,e:f;g<h>i[j\k]l},
      %Q{just"not"right},
      %Q{this is"not\allowed},
      %Q{this\ still\"not\\allowed},
      %Q{john..doe},
      %Q{ invalid},
      %Q{invalid },
      %Q{abc"defghi"xyz},
    ].each do |local|
      assert_equal false, EmailAddr::Local.new(local, local_fix: false).standard?, local
    end
  end

  def test_relaxed
    assert EmailAddr::Local.new("first..last", local_format: :relaxed).valid?, "relax.."
    assert EmailAddr::Local.new("first.-last", local_format: :relaxed).valid?, "relax.-"
    assert EmailAddr::Local.new("a", local_format: :relaxed).valid?, "relax single"
    assert ! EmailAddr::Local.new("firstlast_", local_format: :relaxed).valid?, "last_"
  end

  def test_unicode
    assert ! EmailAddr::Local.new("üñîçøðé1", local_encoding: :ascii).standard?, "not üñîçøðé1"
    assert EmailAddr::Local.new("üñîçøðé2", local_encoding: :unicode).standard?, "üñîçøðé2"
    assert EmailAddr::Local.new("test", local_encoding: :unicode).valid?, "unicode should include ascii"
    assert ! EmailAddr::Local.new("üñîçøðé3").valid?, "üñîçøðé3 valid"
  end


  def test_valid_conventional
    %w( first.last first First+Tag o'brien).each do |local|
      assert EmailAddr::Local.new(local).conventional?, local
    end
  end

  def test_invalid_conventional
    (%w( first;.last +leading trailing+ o%brien) + ["first space"]).each do |local|
      assert ! EmailAddr::Local.new(local, local_fix:false).conventional?, local
    end
  end

  def test_valid
    assert_equal false, EmailAddr::Local.new("first(comment)", local_format: :conventional).valid?
    assert_equal true, EmailAddr::Local.new("first(comment)", local_format: :standard).valid?
  end

  def test_format
    assert_equal :conventional, EmailAddr::Local.new("can1").format?
    assert_equal :standard, EmailAddr::Local.new(%Q{"can1"}).format?
    assert_equal "can1", EmailAddr::Local.new(%Q{"can1(commment)"}).format(:conventional)
  end

  def test_redacted
    l = "{bea3f3560a757f8142d38d212a931237b218eb5e}"
    assert EmailAddr::Local.redacted?(l), "redacted? #{l}"
    assert_equal :redacted, EmailAddr::Local.new(l).format?
  end

  def test_matches
    a = EmailAddr.new("User+tag@gmail.com")
    assert_equal false,  a.matches?('user')
    assert_equal false,  a.matches?('user@')
    assert_equal 'user*@',  a.matches?('user*@')
  end

  def test_munge
    assert_equal "us*****", EmailAddr::Local.new("User+tag").munge
  end

end
