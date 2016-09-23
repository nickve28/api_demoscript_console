require 'rest-client'
require 'colorize'
require 'json'
require 'yaml'

class Demo
  attr_accessor :config, :actions, :current_action
  #accepts a module which needs to given auth functions

  def initialize(mod, config)
    @config = config
    @actions = @config['actions']

    auth_actions = @config['authentication_token'] || []
    auth_actions.each do |key, value|
      puts "Authenticating #{key}...".yellow
      auth_action = value['action']
      var_name = "@#{key}"
      instance_variable_set(var_name, mod::send(auth_action, auth_actions))
    end
    @current_action = -1
    nextAction
  end

  def print_action
    @actions.each.with_index do |action, i|
      action_desc = action['description']
      puts "#{i}:#{" " * (5 - i.to_s.length)}#{action_desc}"
    end
  end

  def nextAction
    puts 'Continue?'
    gets

    print_action
    puts "Please enter the action number to perform:".light_cyan
    option = Integer(gets.strip) rescue false
    if option
      if option >= @actions.length
        self.current_action = actions.length - 1
      else
        self.current_action = option
      end
    else
      self.current_action += 1
    end

    self.current_action = @actions.length - 1 if (self.current_action >= @actions.length)

    action_config = @actions[self.current_action]
    run_action(action_config)
  end

  def perform_request(method, url, payload, options)
    expectError = options['expect_error'] || false
    verify_ssl = if options.include?('verify_ssl') then options['verify_ssl'] else true end

    puts "Attempting to call #{method.to_s.upcase} #{url} \n".yellow
    unless payload.empty? then
      puts "Using payload:\n".light_cyan
      puts JSON.pretty_generate(payload).green
      puts "\n"
    end

    headers = options['headers'] || {}
    begin
      rest_payload = {
        method: method,
        url: url,
        headers: headers,
        verify_ssl: verify_ssl,
        user: options['user'],
        password: options['password'],
      }
      if (method === :get or method === :delete) then
        rest_payload = rest_payload.merge({payload: payload.to_json})
      end

      response = JSON.parse(RestClient::Request.execute(rest_payload))
      puts "The request returned:\n".light_cyan
      puts JSON.pretty_generate(response).green;
      response
    rescue Exception => e
      puts "An unexpected error happened! \n".red unless expectError
      puts "Error: #{e}".red
      if e.respond_to?(:response) then
        parsed_response = JSON.parse(e.response) rescue {}
        puts JSON.pretty_generate(parsed_response).red #new
      end
    end
  end

  private def prompt(action)
    puts action['value'].light_cyan
    puts "\n"
    puts "Press enter to continue\n"

    action['prompt'].each do |val|
      current_val = instance_variable_get("@#{val}")
      puts "Enter a value for #{val}(#{current_val}):\n"
      v = gets.chomp
      instance_variable_set("@#{val}", v) unless v.empty?
    end
  end

  private def print(action, headers)
    puts action['value'].light_cyan
    puts "\n"
    puts "Press enter to continue\n"
    gets

    domain = action['domain']
    base_url = @config['urls'][domain]

    url = "#{base_url}#{action['url']}"

    preset_url_params = action['preset_url_params'] || {}
    preset_url_params.each do |key, value_preset|
      replace_regex = /{#{key}}/
      url = url.gsub(replace_regex, value_preset)
    end

    url_params = action['url_params'] || []
    url_params.each do |url_param|
      replace_regex = /{#{url_param}}/
      value = instance_variable_get("@#{url_param}") || ""
      url = url.gsub(replace_regex, value)
    end

    payload = action['payload'] || {}
    method = action['method'].to_sym
    if (action['query_params']) then
      qs = action['query_params'].map do |key, value|
        "#{key}=#{value}"
      end.join('&')
      url << "?" << qs
    end

    options = action['options'] || {}
    options = options.merge(headers)
    perform_request(method, url, payload, options)
  end

  private def headers_for(action)
    options = action['options']
    user = options['auth_user']
    if options['auth_type'] == 'basic_auth' then
      user_config = @config['basic_auth'][user]
      {"headers" => { "Content-Type" => "application/json"}, "user" => user_config['user'], "password" => user_config['password' ] }
    else
      token = instance_variable_get("@#{user}")
      {"headers" => { "Content-Type" => "application/json", "Authorization" => "Bearer #{token}" } }
    end
  end

  def run_action(action_config)
    puts action_config['description'].yellow
    puts 'Press enter to continue'
    gets

    action_config['actions'].each do |action|
      if (action['type'] == 'prompt') then
        prompt(action)
      else
        headers = headers_for(action)
        print(action, headers)
      end
      puts "Press enter to continue.."
      gets
    end
    nextAction
  end
end
