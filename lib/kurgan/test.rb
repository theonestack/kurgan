module Kurgan
  class Test < Thor::Group
    include Thor::Actions

    argument :test_name

    class_option :type, aliases: :t, type: :string, enum: %w(config), default: 'config'
    class_option :directory, aliases: :d, type: :string, default: 'tests'

    def self.source_root
      File.dirname(__FILE__)
    end

    def get_cfhighlander_template
      @cfhighlander_template = Dir['*.cfhighlander.rb'][0]
      if @cfhighlander_template.nil?
        raise "No cfhighlander.rb file found in #{Dir.pwd}"
      end
    end

    def create_test
      case options[:type]
      when 'config'
        template('templates/test.yaml.tt', "#{options[:directory]}/#{test_name}.test.yaml")
        say "created config test case #{options[:directory]}/#{test_name}.test.yaml", :green
      else
        error "#{options[:type]} is not a supported test type yet", :red
      end
    end

  end
end
