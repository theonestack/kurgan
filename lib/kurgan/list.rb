require "thor"
require 'terminal-table'
require 'kurgan/github'

module Kurgan
  class List < Thor::Group
    include Thor::Actions

    def get_repos
      repos = Kurgan::GitHub.get_repos()
      if repos.nil?
        abort "Error: Somthing went wrong with connecting to the github api"
      end
      @hl_repos = repos.map {|repo| [repo[:name], repo[:url], repo[:updated_at]]}
    end

    def display
      puts Terminal::Table.new( 
        :headings => ['Component', 'Git URL', 'Last Updated'], 
        :rows => @hl_repos.sort
      )
    end

  end
end
