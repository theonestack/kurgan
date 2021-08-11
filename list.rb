require "thor"
require 'faraday'
require 'json'
require 'terminal-table'

module Kurgan
  class List < Thor::Group
    include Thor::Actions

    def get_repos
      url = 'https://api.github.com/orgs/theonestack/repos'
      response = Faraday.get(url, {type: 'public', per_page: 100}, {'Accept' => 'Accept: application/vnd.github.v3+json'})
      repos = JSON.parse(response.body, symbolize_names: true)
      @hl_repos = repos.select {|repo| repo[:name].start_with?('hl-component')}.map {|repo| [repo[:name], repo[:url], repo[:updated_at]]}
    end

    def display
      puts Terminal::Table.new( 
        :headings => ['Component', 'Git URL', 'Last Updated'], 
        :rows => @hl_repos.sort
      )
    end

  end
end
