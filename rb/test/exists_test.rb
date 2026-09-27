# VoxgigSolardemo SDK exists test

require "minitest/autorun"
require_relative "../VoxgigSolardemo_sdk"

class ExistsTest < Minitest::Test
  def test_create_test_sdk
    testsdk = VoxgigSolardemoSDK.test(nil, nil)
    assert !testsdk.nil?
  end
end
