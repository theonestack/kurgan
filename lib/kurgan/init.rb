require 'thor'

module Kurgan
  class Init < Thor::Group
    include Thor::Actions

    argument :name

    def self.source_root
      File.dirname(__FILE__)
    end

    def set_directory
      @dir = ask "directory name ", default: name
      empty_directory @dir
    end

    def set_description
      @description = ask "template description ", default: name
    end

    def set_template_parameters
      @parameters = []
    end

    def set_template_components
      @components = []
    end

    def create_cfhighlander_template
      opts = {parameters: @parameters, components: @components, description: @description}
      template('templates/cfhighlander.rb.tt', "#{@dir}/#{name}.cfhighlander.rb", opts)
    end

    def create_config_yaml
      template('templates/config.yaml.tt', "#{@dir}/#{name}.config.yaml")
    end

    def git_init
      if yes?("git init project?")
        run("git init #{@dir}")
        template('templates/gitignore.tt', "#{@dir}/.gitignore")
        template('templates/README.md.tt', "#{@dir}/README.md")
      else
        say "Skipping git init", :yellow
      end
    end

  end
end
