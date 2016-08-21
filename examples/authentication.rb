require 'rest-client'
require 'active_support/core_ext/hash/indifferent_access'
require 'json'

module Auth
  def self.api_test(config)
    "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjoic2VjcmV0In0.rB_kdtdgAhEkjrpgFD-z0c2UqaCOnvjrWuye1tJZIB4"
  end

  def self.api_test_invalid(config)
    "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjoibm90bXlzZWNyZXQifQ.JQMLblCDXGEvLt9ZDwViTZbvob2JacSe_TN15_NIpTs"
  end
end
