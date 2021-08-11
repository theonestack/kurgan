require "thor"
require 'faraday'
require 'json'
require 'terminal-table'

module Kurgan
  class Search < Thor::Group
    include Thor::Actions

    argument :component

    def get_releases
      url = "https://api.github.com/repos/theonestack/hl-component-#{component}/releases"
      response = Faraday.get(url, {}, {'Accept' => 'Accept: application/vnd.github.v3+json'})
      
      if response.status == 404
        abort "unable to find component #{component} in theonestack github repositories"
      elsif response.status != 200
        abort "error occured retriving details from github for the component"
      end
      
      releases = JSON.parse(response.body, symbolize_names: true)
      @rows = releases.map {|release| [release[:tag_name], release[:name], release[:published_at], release[:html_url]]}
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
