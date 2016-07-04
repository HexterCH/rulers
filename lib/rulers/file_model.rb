require "multi_json"
require "pry"
module Rulers
  module Model
    class FileModel
      def initialize(filename)
        @filename = filename
        basename = File.split(filename)[-1]

        @id = File.basename(basename, ".json").to_i

        obj = File.read(filename)
        @hash = MultiJson.load(obj)
      end

      def [](name)
        @hash[name.to_s]
      end

      def []=(name, value)
        @hash[name.to_s] = value
      end

      def self.find(id)
        begin
          FileModel.new("db/quotes/#{id}.json")
        rescue Exception => e
          puts e.inspect
        end
      end
    end
  end
end
