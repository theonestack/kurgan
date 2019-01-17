module Kurgan
  class Add < Thor::Group
    include Thor::Actions

    argument :template

    class_option :name, aliases: :n, type: :string
    class_option :version, aliases: :v, type: :string

    def get_cfhighlander_template
      @cfhighlander_template = Dir['*.cfhighlander.rb'][0]
      if @cfhighlander_template.nil?
        raise "No cfhighlander.rb file found in #{Dir.pwd}"
      end
    end

    def get_component_name
      @name = options[:name] || template
    end

    def get_template_version
      @template = options[:version] ? "#{template}@#{options[:version]}" : template
      say "adding #{@template} to the #{@cfhighlander_template.split('.')[0]} project"
    end

    def add_component
      insert_into_file @cfhighlander_template, "  Component name: '#{@name}', template: '#{@template}'\n\n", :before => /^end/
    end

    def create_config
      create_file "#{@name}.config.yaml"
    end

  end
end
