require 'kurgan/init'

module Kurgan
  class Component < Kurgan::Init

    def set_directory
      @dir = ask "directory name ", default: "hl-component-#{name}"
      empty_directory @dir
    end

    def set_description
      @description = ask "template description ", default: "#{name} - \#{component_version}"
    end

    def set_template_parameters
      @parameters = [
        { name: 'EnvironmentName', default: 'dev', options: 'isGlobal: true' },
        { name: 'EnvironmentType', default: 'development', options: "allowedValues: ['development','production'], isGlobal: true" }
      ]
    end

    def create_cfndsl_template
      template('templates/cfndsl.rb.tt', "#{@dir}/#{name}.cfndsl.rb")
    end

    def copy_licence
      if yes?("Use MIT license?")
        copy_file "templates/MITLICENSE", "#{@dir}/LICENSE"
      else
        say "Skipping license", :yellow
      end
    end

    def create_travis_config
      if yes?("Use Travis-ci?")
        copy_file "templates/travis.yml.tt", "#{@dir}/travis-ci.yml"
      else
        say "skipping travis", :yellow
      end
    end

  end
end
