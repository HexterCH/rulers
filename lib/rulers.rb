require "rulers/version"
require "rulers/array"
require "rulers/routing"
require "rulers/util"
require "rulers/dependencies"
require "rulers/controller"
require "rulers/file_model"
require "rulers/view"
require "pry"

module Rulers
  class Application
    def call(env)
      @start_time = Time.now

      if env['PATH_INFO'] == '/favicon.ico'
        return [404, {'Content-Type' => 'text/html'}, []]
      end

      if env['PATH_INFO'] == '/'
        return [200,
          {'Content-Type' => 'text/html'},
          [File.read("public/index.html")]
          ]
      end

      klass, act = get_controller_and_action(env)
      controller = klass.new(env)

      begin
        controller.send(act)

        response = controller.get_response

        unless response
          controller.render(act)
        end

        [
          response.status,
          response.headers,
          [response.body].flatten
        ]
      rescue
        [
          500,
          {'Cpmtemt-Type' => 'text/html'},
          ["This is 500 error page. Sorry, we will fix it soon."]
        ]
      end
    end
  end
end
