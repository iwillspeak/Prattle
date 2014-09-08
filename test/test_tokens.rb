#!/usr/bin/env ruby

require 'test/unit'
require 'prattle/tokens'


class LexerTest < Test::Unit::TestCase

  def create_token_stream(string)
    Prattle::TokenStream.new string
  end

  def test_empty_stream_returns_EOF

    ts = create_token_stream ""

    # check the token we are at looks like an EOF
    assert ts.peek.type == :EOF
    assert ts.match :EOF
    assert ts.chomp :EOF

    # make sure we always get an EOF token once we have reached the
    # end of the stream
    assert ts.peek.type == :EOF
    assert ts.match :EOF
    assert ts.chomp :EOF
  end

  def test_simple_number_token
    
    ts = create_token_stream "1"

    assert ts.match :number
    assert ts.peek.value == 1
    assert ts.chomp :number

    # check we have reached the end of the stream now
    assert ts.match :EOF
  end

  def test_number_values
    
    values = 0..50

    ts = create_token_stream values.map(&:to_s).join(" ")

    values.each do |value|
      tok = ts.peek

      assert tok.type == :number
      assert tok.value == value

      assert ts.chomp :number
    end
  end

  def test_simple_identifiers

    ts = create_token_stream "foo"

    assert ts.peek.type == :identifier
    assert ts.peek.value == "foo"
    assert ts.match :identifier
    assert ts.chomp :identifier

    # Should have reached the end of the stream
    assert ts.match :EOF
  end

  def test_identifier_values
    
    values = [ "foo", "bar", "foo_bar", "baz" ]

    ts = create_token_stream values.join(" ")

    values.each do |value|

      tok = ts.peek

      assert tok.type == :identifier
      assert tok.value == value

      assert ts.chomp :identifier
    end
  end

  def test_underscored_identifier
    
    ts = create_token_stream "foo_bar"

    tok = ts.peek
    assert tok.type == :identifier
    assert tok.value == "foo_bar"
    assert ts.match :identifier
    assert ts.chomp :identifier

    assert ts.peek.type == :EOF
  end

  def test_operators

    values = [ "-", "+", "=", "||", "--", "++", "*", "^" ]

    ts = create_token_stream values.join " "
    
    values.each do |value|
      assert ts.peek.type == value.to_sym
      assert ts.peek.value == value.to_sym
      assert ts.chomp value.to_sym
    end

    assert ts.match :EOF
  end

  def test_prefix_postfix_operators

    ts = create_token_stream "-1 + --2++"

    assert ts.chomp :-
    assert ts.chomp :number
    assert ts.chomp :+
    assert ts.chomp "--".to_sym
    assert ts.chomp :number
    assert ts.chomp "++".to_sym
    assert ts.chomp :EOF
  end

  def test_infix_operators
    ts = create_token_stream "a+b*4/2"

    assert ts.chomp :identifier
    assert ts.chomp :+
    assert ts.chomp :identifier
    assert ts.chomp :*
    assert ts.chomp :number
    assert ts.chomp :/
    assert ts.chomp :number
    assert ts.chomp :EOF
  end

end
