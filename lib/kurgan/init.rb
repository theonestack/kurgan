require 'thor'
require 'kurgan/projects'

module Kurgan
  class Init < Thor::Group
    include Thor::Actions

    argument :name

    class_option :project, aliases: '-p', default: 'empty', enum: ['empty','vpc','ecs'], desc: "Create a pre-canned project"

    def self.source_root
      File.dirname(__FILE__)
    end

    def set_type
      @type = 'project'
    end

    def set_directory
      @dir = ask "directory name ", default: name
      empty_directory @dir
    end

    def set_description
      @description = ask "template description ", default: name
    end

    def set_template_parameters
      @parameters = Kurgan::Projects.properties[options['project'].to_sym][:parameters]
    end

    def set_template_components
      @components = Kurgan::Projects.properties[options['project'].to_sym][:components]
    end

    def create_cfhighlander_template
      opts = {parameters: @parameters, components: @components, description: @description}
      template 'templates/cfhighlander.rb.tt', "#{@dir}/#{name}.cfhighlander.rb", opts
    end

    def create_config_yaml
      template 'templates/config.yaml.tt', "#{@dir}/#{name}.config.yaml"
    end

    def create_readme
      template "templates/README.md.project.tt", "#{@dir}/README.md"
    end

    def git_init
      if yes? "git init project?"
        run "git init #{@dir}"
        template 'templates/gitignore.tt', "#{@dir}/.gitignore"
      else
        say "Skipping git init", :yellow
      end
    end

    def ci_init
      if yes? "Setup a CI pipeline?"
        ci = ask "CI flavour", limited_to: ['github', 'jenkins', 'codebuild']
        case ci
        when 'github'
          template 'templates/github_actions.yaml.tt', "#{@dir}/.github/workflows/rspec.yaml"
          insert_into_file "#{@dir}/README.md", 
            "![cftest](https://github.com/theonestack/hl-component-#{name}/actions/workflows/rspec.yaml/badge.svg)\n\n", 
            :after => /^# #{name} CfHighlander Component\n\n/
        when 'jenkins'
          template 'templates/Jenkinsfile.tt', "#{@dir}/Jenkinsfile"
        when 'codebuild'
          template 'templates/codebuild.yaml.tt', "#{@dir}/.codebuild.yaml"
        end
      else
        say "Skipping CI setup", :yellow
      end
    end

  end
end
