require "thor"
require 'terminal-table'

module Kurgan
  class Inspect < Thor::Group
    include Thor::Actions

    def get_cfhighlander_template
      @cfhighlander_rb = Dir['*.cfhighlander.rb'][0]
      if @cfhighlander_rb.nil?
        raise "No cfhighlander.rb file found in #{Dir.pwd}"
      end
    end

    def get_project_name
      @project_name = @cfhighlander_rb.split('.').first
    end

    def get_components
      cfhighlander_file = File.read(@cfhighlander_rb)
      raw_components = cfhighlander_file.scan(/template:\s?(.*?)\s/).flatten
      
      @components = raw_components.map do |template_str|
        template = template_str.strip.gsub(/("|'|,)/, '').split(/(@|#)/)        
        { template: template.first, version: (template.size > 1 ? template.last : "not found") }
      end
    end

    def check_versions
      @components.each do |comp|
        releases = Kurgan::GitHub.get_releases(comp[:template])
        if !releases.nil? && releases.any? 
          latest_release = releases.sort_by { |r| r[:tag_name] }.reverse.first
          comp[:latest_release] = latest_release[:tag_name]
        else
          comp[:latest_release] = 'not found'
        end
      end
    end

    def display
      puts Terminal::Table.new(
        :title => "Project: #{@project_name}",
        :headings => ['Component', 'Version', 'Latest Release'], 
        :rows => @components.map {|comp| [comp[:template], comp[:version], comp[:latest_release]] }
      )
    end

  end
end
