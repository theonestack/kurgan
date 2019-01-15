require "thor"
require "kurgan/version"
require "kurgan/init"
require "kurgan/component"

require "kurgan/projects/ecs"

module Kurgan
  class Cli < Thor

    map %w[--version -v] => :__print_version
    desc "--version, -v", "print the version"
    def __print_version
      puts Kurgan::VERSION
    end

    # Generats new project
    register Kurgan::Init, 'project', 'project [name]', 'Generates a new CfHighalnder project'
    tasks["project"].options = Kurgan::Init.class_options

    # Generats new ecs project
    register Kurgan::Ecs, 'ecs', 'ecs [name]', 'Generates a new CfHighalnder ECS project'
    tasks["ecs"].options = Kurgan::Ecs.class_options

    # Generates a new component
    register Kurgan::Component, 'component', 'component [name]', 'Generates a new CfHighalnder component'
    tasks["component"].options = Kurgan::Component.class_options

  end
end
