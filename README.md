# Kurgan
---
![build workflow](https://github.com/theonestack/kurgan/actions/workflows/build-gem.yml/badge.svg)
![release workflow](https://github.com/theonestack/kurgan/actions/workflows/release-gem.yml/badge.svg)

Command line tool to create and manage CfHighlander projects and components

## Setup

```sh
gem install kurgan
```

## Usage

### Help

view all available commands

```bash
➜  kurgan help
Commands:
  kurgan --version, -v       # print the version
  kurgan add [component]     # Adds a new component to an existing CfHighlander project
  kurgan component [name]    # Generates a new CfHighlander component
  kurgan extend [component]  # Generates a files to extend a component in a CfHighlander project
  kurgan help [COMMAND]      # Describe available commands or one specific command
  kurgan inspect             # inspect a cfhighlander files of it's components
  kurgan list                # list all components in the onestack
  kurgan project [name]      # Generates a new CfHighlander project
  kurgan search [component]  # search for a component and it's release history
  kurgan test [name]         # Create a new test case for a component
```

help can also be used on commands to see available options and usage

```bash
➜  kurgan help project
Usage:
  kurgan project [name]

Options:
  -p, [--project=PROJECT]  # Create a pre-canned project
                           # Default: empty
                           # Possible values: empty, vpc, ecs

Generates a new CfHighlander project
```

### Create a New Project

A CfHighlander project allows you to configure and compile a group of components to generate you Cloudformation stack.

To create a new project run the `project` command with the name of your new project and fill in the prompts

```sh
➜  kurgan project myproject
directory name  (myproject)
      create  myproject
template description  (myproject)
      create  myproject/myproject.cfhighlander.rb
      create  myproject/myproject.config.yaml
git init project? y
         run  git init myproject from "."
Initialized empty Git repository in /Users/gus/src/testbed/hl/myproject/.git/
      create  myproject/.gitignore
      create  myproject/README.md
Setup a CI pipeline? y
CI flavour [github, jenkins, travis, codebuild] jenkins
      create  myproject/Jenkinsfile
```

cd into the new directory and you'll see the following project structure

```txt
.
├── Jenkinsfile # depending on CI flavour this will be different
├── README.md
├── myproject.cfhighlander.rb
└── myproject.config.yaml
```


### Add a Component to a Project

To add a component to your nproject use the `add` command along with the component name with optional component version and friendly name

```sh
➜  myproject git:(master) ✗ kurgan add vpc-v2 --name network --version 0.7.0
adding vpc-v2@0.7.0 to the myproject project
      insert  myproject.cfhighlander.rb
      create  network.config.yaml
```

this will create a yaml config file for the new component configuration and add the component to the `myproject.cfhighlander.rb` file

```rb
CfhighlanderTemplate do
  Name 'myproject'
  Description "myproject"
  Component name: 'network', template: 'vpc-v2@0.7.0'
end
```


### Extend a Component in a Project

Extending a component allows you to add resources to an existing component whilest still allowing you to update the component.

to extend a component use the `extend` command along with the component name with optional component version and friendly name

```sh
➜  myproject git:(master) ✗ kurgan extend aurora-mysql --name database --version 3.3.0
      create  database
extending aurora-mysql@3.3.0 to the myproject project
      create  database/database.cfhighlander.rb
      create  database/database.config.yaml
      create  database/database.cfndsl.rb
      insert  myproject.cfhighlander.rb
```

this will create a new sub directory with a cfhighlander file containing the component you're extending, a cfndsl file to add your resources and a config.yaml for configuration

```txt
.
├── Jenkinsfile
├── README.md
├── database
│   ├── database.cfhighlander.rb
│   ├── database.cfndsl.rb
│   └── database.config.yaml
├── myproject.cfhighlander.rb
├── myproject.config.yaml
└── network.config.yaml
```

```rb
CfhighlanderTemplate do
  Name 'database'
  Extends 'aurora-mysql@3.3.0'
end
```


### Inspect a Project

To see a list of components used by a project including versions and latest available version use the `inspect` command.

```sh
➜  myproject git:(master) ✗ kurgan inspect
+-----------+-----------+----------------+
|           Project: myproject           |
+-----------+-----------+----------------+
| Component | Version   | Latest Release |
+-----------+-----------+----------------+
| vpc-v2    | 0.7.0     | 0.7.0          |
+-----------+-----------+----------------+
```


### Create a New Component

Components are the basic building blocks of CfHighlander, containing cloudformation resources that can be templated and reused across multiple project.

To create a new project use the `component` command with the name of your new component and fill in the prompts

```txt
➜  kurgan component rds-mysql
directory name  (hl-component-rds-mysql)
      create  hl-component-rds-mysql
template description  (rds-mysql - #{component_version})
      create  hl-component-rds-mysql/rds-mysql.cfhighlander.rb
      create  hl-component-rds-mysql/rds-mysql.config.yaml
git init project? y
         run  git init hl-component-rds-mysql from "."
Initialized empty Git repository in /Users/gus/src/testbed/hl/hl-component-rds-mysql/.git/
      create  hl-component-rds-mysql/.gitignore
      create  hl-component-rds-mysql/README.md
Setup a CI pipeline? y
CI flavour [github, jenkins, travis, codebuild] github
      create  hl-component-rds-mysql/.github/workflows/spec.yaml
      create  hl-component-rds-mysql/rds-mysql.cfndsl.rb
      create  hl-component-rds-mysql/tests/default.test.yaml
Use MIT license? y
      create  hl-component-rds-mysql/LICENSE
```

the following folder structure is generated

```txt
.
├── LICENSE
├── README.md
├── rds-mysql.cfhighlander.rb
├── rds-mysql.cfndsl.rb
├── rds-mysql.config.yaml
└── tests
    └── default.test.yaml
```


### Add tests to a Component

Kurgan can be used to add configuration tests to a component as well as generating spec tests based upon the cloudformation generated by a configuration test.

to create a new config test run the test command along with the name of the test

```sh
➜  hl-component-rds-mysql git:(master) ✗ kurgan test mytest
      create  tests/mytest.test.yaml
created config test case tests/mytest.test.yaml
```

A test.yaml file is created in the tests directory, add in you test and run the `cfhighlander test` command to execute the test

Once the cftest has successfully passed you can then generate a spec test from the cloudformation template generated by the test in the `out/tests/<test-name>/` directory

To generate the spec test use the `test` command again with the name of the test and pass the `--type spec` flag

```sh
➜  hl-component-rds-mysql git:(master) ✗ kurgan test mytest --type spec
      create  spec/mytest_spec.rb
created spec test spec/mytest_spec.rb
```


### Searching for Components

to list all available components on the onestack use the `list` command

```sh
➜  kurgan list
```

to search for a components releases use the `search [component]` command

```sh
➜  kurgan search vpc
```


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
