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
        return [
          200,
          {'Content-Type' => 'text/html'},
          [File.read("public/index.html")]
        ]
      end

      rack_app = get_rack_app(env)
      rack_app.call(env)
    end
  end
end
