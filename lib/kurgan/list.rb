require 'open-uri'
require 'fileutils'

module Kurgan
  class List

    def initialize(options)
      @filter = options[:filter]
      @component = options[:component]
      if options[:update] || !File.exists?(Kurgan.components_file)
        update_component_list
      end
      content = File.read(Kurgan.components_file)
      @components = JSON.parse(content)['components']
    end

    def execute
      puts "\n\s\s============================="
      puts "\s\s## CfHighlander Components ##"
      puts "\s\s=============================\n\n"
      if @component
        return component
      elsif @filter
        return filter
      else
        return all
      end
    end

    def component
      components = @components.select { |comp| comp['name'].include? @component }
      abort "no match for component #{@component}" if !components.any?
      components.each { |comp| puts "\s\s\s\s#{comp['name']} (#{comp['versions'].join(', ')})" }
    end

    def filter
      components = @components.select { |comp| comp['filter'].include? @filter }
      abort "no match for filter #{@filter}" if !components.any?
      components.each { |comp| format(comp['name'],comp['latest']) }
    end

    def all
      @components.each { |comp| format(comp['name'],comp['latest']) }
    end

    def format(name,version)
      version = version != "" ? version : 'latest'
      puts "\s\s\s\s#{name}@#{version}"
    end

    def update_component_list
      puts "Updating components list"
      FileUtils.mkdir_p File.dirname(Kurgan.components_file)
      content = open('https://s3-ap-southeast-2.amazonaws.com/cfhighlander-component-specification/components.json').read
      File.open(Kurgan.components_file, 'w') { |f| f.puts content }
      puts "Succesfully updated components list #{Kurgan.components_file}"
    end

  end
end
