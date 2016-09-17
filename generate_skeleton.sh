#!/usr/bin/env bash

#Generate dummy scenario file
cat >./scenarios.yml <<EOL
---
authentication_token:
  example:
    action: api_test
basic_auth:
  tester:
    username: foo
    password: bar

urls:
  api: http://localhost/api

actions:
  -
    description: get example
    actions:
      -
        type: prompt
        value: "Enter an item id"
        prompt:
          - item_id
      -
        type: print
        value:  get item
        domain: api
        method: get
        url: /items/{item_id}
        query_params:
          fields: name,id
        url_params:
          - item_id
        options:
          auth_type: authentication_token
          auth_user: test
  -
    description: post example
    actions:
      -
        type: print
        value: "Create item"
        domain: api
        method: post
        payload:
          name: foo
          description: bar
        url: /items
        options:
          auth_type: authentication_token
          auth_user: test
EOL

#Generate dummy auth module
cat >./auth.rb << EOL
require 'rest-client'
require 'active_support/core_ext/hash/indifferent_access'
require 'json'

module Auth
  def self.api_test(config)
    "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjoic2VjcmV0In0.rB_kdtdgAhEkjrpgFD-z0c2UqaCOnvjrWuye1tJZIB4"
  end
end
EOL

#Generate runner
cat >./main.rb << EOL
require './demo.rb'
require './auth.rb'
require 'yaml'

config = YAML.load_file("./scenarios.yml")

Demo.new Auth, config
EOL
