require 'yaml'

module Kurgan
  class Test < Thor::Group
    include Thor::Actions

    argument :test_name

    class_option :type, aliases: :t, type: :string, enum: %w(config spec), default: 'config'
    class_option :directory, aliases: :d, type: :string, default: 'tests'

    def self.source_root
      File.dirname(__FILE__)
    end

    def get_cfhighlander_template
      @cfhighlander_template = Dir['*.cfhighlander.rb'][0]
      if @cfhighlander_template.nil?
        raise "No cfhighlander.rb file found in #{Dir.pwd}"
      end
      @component_name = @cfhighlander_template.split('.').first
    end

    def create_test
      case options[:type]
      when 'config'
        template('templates/test.yaml.tt', "#{options[:directory]}/#{test_name}.test.yaml")
      when 'spec'
        if test_name == '*'
          test_yamls = Dir["tests/*.test.yaml"]
          tests = test_yamls.map {|test_yaml| test_yaml[/tests\/(.*).test.yaml/, 1]}
        else
          tests = [test_name]
        end

        tests.each do |name|
          output_file = "#{Dir.pwd}/out/tests/#{name}/#{@component_name}.compiled.yaml"
          if !File.file?(output_file)
            warn "compile cloudformation test output file #{output_file} not found.\nRun `cfhighlander cftest -t #{options[:directory]}/#{name}.test.yaml`"
          end
          compiled_test = YAML.load_file("#{Dir.pwd}/out/tests/#{name}/#{@component_name}.compiled.yaml")
          template('templates/test.spec.tt', "spec/#{name}_spec.rb", {compiled_test: compiled_test, test_name: name})
        end
      else
        error "#{options[:type]} is not a supported test type yet", :red
      end
    end

  end
end
