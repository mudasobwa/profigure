require 'profigure/version'
require 'hash_deep_merge'

# @author Alexei Matyushkin
#
# Module to use as is, to monkeypatch it, or to extend in order to have
#   nice and easy config files support.
#
# It’s designed to be as intuitive as possible.
#
# _Usages:_
#
# Say, we have the following `config.yml` file:
#
#     :version : '0.0.1'
#     :nested :
#       :sublevel :
#         :value : 'test'
#     :url : 'http://example.com'
#     :configs :
#       - 'config/test1.yml'
#       - 'config/test2.yml'
#
# Then:
#
#     config = (Profigure.load 'config/config.yml').configure do
#       set :foo, 'bar'
#       set :fruits, ['orange', 'apple', 'banana']
#     end
#
#     puts config.nested.sublevel.value
#     # ⇒ 'test'
#     config.nested = { :newvalue => 'test5' }
#     # ⇒ 'test5'
#
# _Setting deeply nested values with this syntax is **not yet allowed**._
#
# ----
#
# The handlers for `YAML` section might be specified with double underscore.
#   When set, the handler will be called with value to operate it.
#
#  As an example, let’s take a look at the following code:
#
#      module ProfigureExt
#        extend Profigure
#
#        def self.__configs key, *args
#          key = [*args] unless (args.empty?) # setter
#
#          @configs ||= ProfigureExt.clone
#          @configs.clear
#
#          key.each { |inc| @configs.push inc } unless key.nil?
#
#          @configs.to_hash
#        end
#      end
#
#  Here the handler is defined for `configs` section. Once found, the section
#    will be passed to this handler, which apparently loads the content of
#    included config files.
#
#  *NB* The name alludes both to “pro” vs. “con” and to “pro” vs. “lite”. Enjoy.
#
module Profigure

  # Methods to propagate to modules which will `extend Profigure`
  module ClassMethods

    # A wrapper for the configuration block
    # @param block the block to be executed in the context of this module
    def configure &block
      instance_eval(&block)
    end

    # Getter for values by keys
    # @param key the key to retrieve the value for
    # @return the value retrieven
    def [] key
      Hash === config[key.to_sym] ?
        self.clone.push(config[key.to_sym]) : config[key.to_sym]
    end

    # Setter for values by keys
    # @param key the key to set the value for
    # @return the value set
    def []= key, value
      config[key.to_sym] = value
    end

    # Clears the underlying hash
    # @return `self`
    def clear
      @config = {}
      self
    end

    # Loads parameters from `stream`, file by `filename` or `hash`. Inits
    #   the underlying hash empty when called without args
    # @return `self`
    def push input = nil
      config.deep_merge!  case input
                          when IO     then YAML.load_stream(input)
                          when String then YAML.load_file(input)
                          when Hash   then input
                          else {}
                          end
      self
    end
    alias_method :load, :push

    # Saves the properties to a file
    # @return the result of respective `File.write` operation
    def store file
      File.write file, YAML.dump(to_hash)
    end

    # @return Read-only copy of the underlying hash
    def to_hash
      config.clone
    end

    # @return Empty initialized instance
    def instance
      @instance ||= self.push
    end

  private

    def set(key, value)
      config[key.to_sym] = value
    end

    def add(key, value)
      config[key.to_sym] = [*config[key.to_sym]] << value
    end

    def config
      (@config ||= {})[self] ||= Hash.new
    end

    def method_missing sym, *args, &cb
      if sym =~ /(.+)=$/
        sym = $1.to_sym
        singleton_method(:"__#{sym}").call(args.first, args) if singleton_methods.include?(:"__#{sym}")
        self[sym] = args.first
      else
        singleton_methods.include?(:"__#{sym}") ?
          singleton_method(:"__#{sym}").call(self[sym]) : self[sym]
      end
    end

  end

  extend ClassMethods

  def self.extended other
    other.extend ClassMethods
  end

end

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