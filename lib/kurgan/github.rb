require 'faraday'
require 'json'

module Kurgan
  class GitHub

    GITHUB_URL = "https://api.github.com"
    GITHUB_ORG = "theonestack"

    def self.get_repos
      url = "#{GITHUB_URL}/orgs/#{GITHUB_ORG}/repos"
      response = Faraday.get(url, {type: 'public', per_page: 100}, {'Accept' => 'Accept: application/vnd.github.v3+json'})

      if response.status != 200
        return nil
      end
      
      repos = JSON.parse(response.body, symbolize_names: true)
      return repos.select {|repo| repo[:name].start_with?('hl-component')}
    end

    def self.get_releases(component)
      url = "#{GITHUB_URL}/repos/#{GITHUB_ORG}/hl-component-#{component}/releases"
      response = Faraday.get(url, {}, {'Accept' => 'Accept: application/vnd.github.v3+json'})
      
      if response.status != 200
        return nil
      end
      
      return JSON.parse(response.body, symbolize_names: true)
    end

  end
end
