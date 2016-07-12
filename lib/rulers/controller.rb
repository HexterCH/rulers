require "rulers/file_model"
require "erubis"
require "rack/request"
require "rulers/view"

module Rulers
  class Controller
    include Rulers::Model

    def initialize(env)
      @env = env
      @routing_params = {}
    end

    def dispatch(action, routing_params = {})
      begin
        @routing_params = routing_params

        text = self.send(action)
        response = get_response

        if response
          [
            response.status,
            response.headers,
            [response.body].flatten
          ]
        else
          [
            200,
            {'Cpmtemt-Type' => 'text/html'},
            [text].flatten
          ]
        end
      rescue
        [
          500,
          {'Cpmtemt-Type' => 'text/html'},
          ["This is 500 error page. Sorry, we will fix it soon."]
        ]
      end
    end

    def self.action(act, rp = {})
      proc { |e| self.new(e).dispatch(act, rp) }
    end

    def env
      @env
    end

    def user_agent
      @env[]
    end

    def request_start_time
      @start_time
    end

    def instance_vars
      vars = {}
      instance_variables.each do |name|
        vars[name[1..-1]] = instance_variable_get name.to_sym
      end
      vars
    end

    def request
      @request ||= Rack::Request.new(@env)
    end

    def params
      request.params.merge(@routing_params)
    end

    def response(text, status = 200, headers = {})
      raise "Already responded!" if @response
      a = [text].flatten
      @response = Rack::Response.new(a, status, headers)
    end

    def get_response
      @response
    end

    def render(*args)
      response(render_template(*args))
    end

    def controller_name
      klass = self.class
      klass = klass.to_s.gsub(/Controller$/, "")
      Rulers.to_underscore klass
    end

    def render_template(view_name, locals = instance_vars)
      filename = File.join "app", "views", controller_name, "#{view_name}.html.erb"
      template = File.read filename
      v = View.new
      v.set_vars instance_hash
      v.evaluate template
    end

    def instance_hash
      h = {}
      instance_variables.each do |i|
        h[i] = instance_variable_get i
      end
      h
    end
  end
end
