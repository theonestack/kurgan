require "thor"
require "json"
require "kurgan/version"
require 'kurgan/globals'
require "kurgan/init"
require "kurgan/component"
require "kurgan/add"
require "kurgan/test"
require "kurgan/list"

module Kurgan
  class Cli < Thor

    map %w[--version -v] => :__print_version
    desc "--version, -v", "print the version"
    def __print_version
      puts Kurgan::VERSION
    end

    register Kurgan::Init, 'project', 'project [name]', 'Generates a new CfHighlander project'
    tasks["project"].options = Kurgan::Init.class_options

    register Kurgan::Component, 'component', 'component [name]', 'Generates a new CfHighlander component'
    tasks["component"].options = Kurgan::Component.class_options

    register Kurgan::Add, 'add', 'add [component]', 'Adds a new component to an existing CfHighlander project'
    tasks["add"].options = Kurgan::Add.class_options

    register Kurgan::Test, 'test', 'test [name]', 'Create a new test case for a component'
    tasks["test"].options = Kurgan::Test.class_options

    desc "list", "List available components and latest version from theonestack github"
    method_option :filter, aliases: '-f', type: :string, desc: "filter components by service type"
    method_option :component, aliases: '-c', type: :string, desc: "list all versions for matched components"
    method_option :update, aliases: '-u', type: :boolean, lazy_default: true, default: false, desc: "Update components list"
    def list
      cmd = Kurgan::List.new(options)
      cmd.execute
    end


  end
end
