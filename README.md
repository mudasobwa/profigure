# Profigure

#### The name alludes both to “pro” vs. “con” and to “pro” vs. “lite”. Enjoy.       [![Build Status](https://travis-ci.org/mudasobwa/profigure.png)](https://travis-ci.org/mudasobwa/profigure)

----

 Module to use as is, to monkeypatch it, or to extend in order to have
   nice and easy config files support.

 It’s designed to be as intuitive as possible.

## Usage

 Say, we have the following `config.yml` file:

```yaml
:version : '0.0.1'
:nested :
    :sublevel :
        :value : 'test'
:url : 'http://example.com'
:configs :
    - 'config/test1.yml'
    - 'config/test2.yml'
```

 Then:

```ruby
 config = (Profigure.load 'config/config.yml').configure do
   set :foo, 'bar'
   set :fruits, ['orange', 'apple', 'banana']
 end

 puts config.nested.sublevel.value
 # ⇒ 'test'
 config.nested = { :newvalue => 'test5' }
 # ⇒ 'test5'
```

_Setting deeply nested values with this syntax is **not yet allowed**._

----

 The handlers for `YAML` section might be specified with double underscore.
   When set, the handler will be called with value to operate it.

  As an example, let’s take a look at the following code:

```ruby
module ProfigureExt
    extend Profigure

    def self.__configs key, *args
        key = [*args] unless (args.empty?) # setter

        @configs ||= ProfigureExt.clone
        @configs.clear

        key.each { |inc| @configs.push inc } unless key.nil?

        @configs.to_hash
    end
end
```

  Here the handler is defined for `configs` section. Once found, the section
    will be passed to this handler, which apparently loads the content of
    included config files.

## Installation

Add this line to your application's Gemfile:

    gem 'profigure'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install profigure

## Contributing

1. Fork it ( https://github.com/[my-github-username]/profigure/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
