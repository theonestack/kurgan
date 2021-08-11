require "thor"
require 'terminal-table'
require 'kurgan/github'

module Kurgan
  class Search < Thor::Group
    include Thor::Actions

    argument :component

    def get_releases    
      releases = Kurgan::GitHub.get_releases(component)
      if releases.nil?
        abort "ERROR: unable to find component in theonestack"
      end

      if releases.any?
        @rows = releases.map {|release| [release[:tag_name], release[:name], release[:published_at], release[:html_url]]}
      else
        tags = Kurgan::GitHub.get_tags(component)
      end
    end

    def display
      puts Terminal::Table.new(
        :title => "Component: #{component}",
        :headings => ['Version', 'name', 'Published', 'URL'], 
        :rows => @rows.sort.reverse
      )
    end

  end
end
