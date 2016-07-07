require "rulers/version"
require "rulers/array"
require "rulers/routing"
require "rulers/util"
require "rulers/dependencies"
require "rulers/controller"
require "rulers/file_model"

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
        text = controller.send(act)
        r = controller.get_response

        if r
          [
            r.status,
            r.headers,
            [r.body].flatten
          ]
        else
          [
            200,
            {'Content-Type' => 'text/html'},
            [text]
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
  end
end
