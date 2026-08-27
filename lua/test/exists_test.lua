-- Solardemo SDK exists test

local sdk = require("solardemo_sdk")

describe("SolardemoSDK", function()
  it("should create test SDK", function()
    local testsdk = sdk.test(nil, nil)
    assert.is_not_nil(testsdk)
  end)
end)
