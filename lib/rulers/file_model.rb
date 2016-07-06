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

      def self.all
        files = Dir["db/quotes/*.json"]
        files.map { |f| FileModel.new f }
      end

      def self.create(attrs)
        hash = {}
        hash["submitter"] = attrs["submitter"] || ""
        hash["quote"] = attrs["quote"] || ""
        hash["attribution"] = attrs["attribution"] || ""

        files = Dir["db/quotes/*.json"]
        names = files.map { |f| f.split("/")[-1]}
        highest = names.map { |b| b.to_i }.max
        id = highest + 1

        File.open("db/quotes/#{id}.json", "w") do |f|
          f.write MultiJson.dump hash
        end

        FileModel.new "db/quotes/#{id}.json"
      end

      def self.find(id)
        id = id.to_i
        @dm_style_cache ||= {}

        begin
          if @dm_style_cache[id]
            return @dm_style_cache[id]
          end
          m = FileModel.new("db/quotes/#{id}.json")
          @dm_style_cache[id] = m
          m
        rescue
          return nil
        end
      end

      def self.find_all_by_attrib(attrib, value)
        id = 1
        results = []

        loop do
          m = FileModel.find(id)
          return results unless m

          results.push(m) if m[attrib] == value

          id += 1
        end
      end

      def save
        hash = {}
        hash["submitter"] = @hash["submitter"]
        hash["quote"] = @hash["quote"]
        hash["attribution"] = @hash["attribution"]

        File.open(@filename, "w") do |f|
          f.write MultiJson.dump hash
        end
      end
    end
  end
end
