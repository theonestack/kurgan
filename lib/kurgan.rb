require "thor"
require "json"
require "kurgan/version"
require 'kurgan/globals'
require "kurgan/init"
require "kurgan/component"
require "kurgan/add"
require "kurgan/test"
require "kurgan/list"
require "kurgan/extend"
require "kurgan/search"

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

    register Kurgan::Extend, 'extend', 'extend [component]', 'Generates a files to extend a component in a CfHighlander project'
    tasks["extend"].options = Kurgan::Extend.class_options

    register Kurgan::Test, 'test', 'test [name]', 'Create a new test case for a component'
    tasks["test"].options = Kurgan::Test.class_options

    register Kurgan::List, 'list', 'list', 'list all components in the onestack'
    tasks["list"].options = Kurgan::List.class_options

    register Kurgan::Search, 'search', 'search [component]', "search for a component and it's release history"
    tasks["search"].options = Kurgan::Search.class_options

  end
end
