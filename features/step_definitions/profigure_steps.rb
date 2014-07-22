# ============================ GIVEN ============================

Given(/^the config file is requested$/) do
  @config = Profigure::push 'config/config.yml'
end

Given(/^the config file is requested by extended 'ProfigureExt'$/) do
  @config = ProfigureExt::instance.push 'config/config.yml'
end

Given(/^the value for "(.*?)" key is set to "(.*?)"$/) do |arg1, arg2|
  @config[arg1] = arg2
end

Given(/^the value for version key is set to "(.*?)"$/) do |arg1|
  @config.version = arg1
end

Given(/^the value for version key is set to "(.*?)" with call to configure$/) do |arg1|
  Profigure::configure do
    set :version, arg1
    set :configs, ['config/test1.yml', 'config/test3.yml']
  end
end

# ============================ WHEN =============================

When(/^the value for "(.*?)" key is retrieven$/) do |arg1|
  @result = @config[arg1]
end

When(/^the nested value 'nested\.sublevel\.value' is retrieven$/) do
  @result = @config.nested.sublevel.value
end

When(/^the nested value 'nested' is set to hash ':newvalue => "(.*?)"'$/) do |arg1|
  @config.nested = { :newvalue => 'test5' }
end

When(/^the nested value 'nested\.newvalue' is retrieven$/) do
  @result = @config.nested.newvalue
end

When(/^the nested value 'configs' is retrieven$/) do
  @result = @config.configs
end

When(/^the nested value 'configs' is set$/) do
  @config.configs = ['config/test1.yml']
end

# ============================ THEN =============================

Then(/^the result equals to "(.*?)"$/) do |arg1|
  expect(@result.to_s).to eq(arg1)
end

Then(/^the version number equals to "(.*?)"$/) do |ver|
  expect(@config.version).to eq(ver)
end

Then(/^puts the original hash$/) do
  puts @config.to_hash
  puts @config.nested.to_hash
end

Then(/^puts the value of configs$/) do
  puts @config.configs
end
