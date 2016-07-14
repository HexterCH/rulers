class RouteObject
  def initialize
    @rules = []
  end

  def match(url, *args)
  end

  def check_url
  end
end

module Rulers
  class Application
    def route(&block)
      @route_obj ||= RouteObject.new
      @route_obj.instance_eval(&block)
    end

    def get_rack_app(env)
      raise "No routes!" unless @route_obj
      @route_obj.check_url env["PATH_INFO"]
    end
  end
end
