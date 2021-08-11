require 'kurgan/init'

module Kurgan
  class Component < Kurgan::Init

    def set_type
      @type = 'component'
    end

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

    def create_readme
      template "templates/README.md.component.tt", "#{@dir}/README.md"
    end

    def create_default_config_test
      @test_name = 'default'
      template('templates/test.yaml.tt', "#{@dir}/tests/#{@test_name}.test.yaml")
    end

    def copy_licence
      if yes?("Use MIT license?")
        copy_file "templates/MITLICENSE", "#{@dir}/LICENSE"
      else
        say "Skipping license", :yellow
      end
    end

  end
end
