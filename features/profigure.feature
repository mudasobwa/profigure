# encoding: utf-8

Feature: The configuration file should be loaded and operated easily

  Scenario: Load the file from default location
   Given the config file is requested
    When the value for "version" key is retrieven
    Then the result equals to "0.0.1"
     And the version number equals to "0.0.1"

  Scenario: Set config value for "version" to "0.0.2"
   Given the config file is requested
     And the value for "version" key is set to "0.0.2"
    When the value for "version" key is retrieven
    Then the result equals to "0.0.2"

  Scenario: Set config value for version to "0.0.2"
   Given the config file is requested
     And the value for version key is set to "0.0.2"
    When the value for "version" key is retrieven
    Then the result equals to "0.0.2"

  Scenario: Set config value for "version" to "0.0.2" via call to configure
   Given the config file is requested
     And the value for version key is set to "0.0.2" with call to configure
    When the value for "version" key is retrieven
    Then the result equals to "0.0.2"
     And puts the original hash

  Scenario: Nested properties should be available via accessors (dot) syntax
   Given the config file is requested
    When the nested value 'nested.sublevel.value' is retrieven
    Then the result equals to "test"
     And puts the original hash

  Scenario: Resetting nesteds
   Given the config file is requested
    When the nested value 'nested' is set to hash ':newvalue => "test5"'
     And the nested value 'nested.newvalue' is retrieven
    Then the result equals to "test5"
     And puts the original hash

  Scenario: Special handlers (getter) for some keys are invoked
   Given the config file is requested by extended 'ProfigureExt'
    When the nested value 'configs' is retrieven
    Then the result equals to "{:name=>"test2", :name1=>"test1", :name2=>"test2"}"

  Scenario: Special handlers (setter) for some keys are invoked
   Given the config file is requested by extended 'ProfigureExt'
    When the nested value 'configs' is set
     And the nested value 'configs' is retrieven
    Then the result equals to "{:name=>"test1", :name1=>"test1"}"
     And puts the original hash
     And puts the value of configs

