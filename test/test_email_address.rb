# encoding: UTF-8
require_relative 'test_helper'

class TestEmailAddr < MiniTest::Test

  def test_new
    a = EmailAddr.new('user@example.com')
    assert_equal 'user', a.local.to_s
    assert_equal 'example.com', a.host.to_s
  end

  def test_canonical
    assert_equal "firstlast@gmail.com", EmailAddr.canonical('First.Last+TAG@gmail.com')
    a = EmailAddr.new_canonical('First.Last+TAG@gmail.com')
    assert_equal 'firstlast', a.local.to_s
  end

  def test_normal
    assert_equal 'user+tag@gmail.com', EmailAddr.normal('USER+TAG@GMAIL.com')
  end

  def test_valid
    assert_equal true, EmailAddr.valid?('user@yahoo.com')
    assert_equal true, EmailAddr.valid?('a@yahoo.com')
  end

  def test_matches
    assert_equal 'yahoo.', EmailAddr.matches?('user@yahoo.com', 'yahoo.')
  end

  def test_reference
    assert_equal 'dfeafc750cecde54f9a4775f5713bf01', EmailAddr.reference('user@yahoo.com')
  end

  def test_redact
    assert_equal '{e037b6c476357f34f92b8f35b25d179a4f573f1e}@yahoo.com', EmailAddr.redact('user@yahoo.com')
  end

  def test_cases
    %w( miles.o'brien@yahoo.com first.last@gmail.com a-b.c_d+e@f.gx
    ).each do |address|
      assert EmailAddr.valid?(address, host_validation: :syntax), "valid?(#{address})"
    end
  end

  def test_empty
    assert_equal "", EmailAddr.normal("")
    assert_equal "", EmailAddr.normal(" ")
  end

end
