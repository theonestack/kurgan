module Kurgan
  class Extend < Thor::Group
    include Thor::Actions

    argument :component

    class_option :name, aliases: :n, type: :string
    class_option :version, aliases: :v, type: :string
    
    def self.source_root
      File.dirname(__FILE__)
    end

    def get_cfhighlander_template
      @cfhighlander_template = Dir['*.cfhighlander.rb'][0]
      if @cfhighlander_template.nil?
        raise "No cfhighlander.rb file found in #{Dir.pwd}, are you in a cfhighlander project folder?"
      end
    end

    def get_component_name
      @name = options[:name] || component
    end

    def create_sub_dir_for_extended_component
      empty_directory @name
    end

    def get_template_version
      @template = options[:version] ? "#{component}@#{options[:version]}" : component
      say "extending #{@template} to the #{@cfhighlander_template.split('.')[0]} project"
    end

    def create_cfhighlander_files
      opts = {template: @template, name: @name}
      template('templates/cfhighlander.extend.rb.tt', "#{@name}/#{@name}.cfhighlander.rb", opts)
      template('templates/config.yaml.tt', "#{@name}/#{@name}.config.yaml")
      template('templates/cfndsl.rb.tt', "#{@name}/#{@name}.cfndsl.rb")
    end

    def add_component
      insert_into_file @cfhighlander_template, "\tComponent name: '#{@name}', template: '#{@name}'\n\n", :before => /^end/
    end

  end
end
  