source 'http://rubygems.org'

# Specify your gem's dependencies in guard-minitest.gemspec
gemspec

# optional development dependencies
require 'rbconfig'

gem     'rake'

if Config::CONFIG["target_os"] =~ /darwin/i
  gem   'rb-fsevent', '>= 0.3'
  gem   'growl',      '~> 1.0'
end
if Config::CONFIG["target_os"] =~ /linux/i
  gem   'rb-inotify', '>= 0.5'
  gem   'libnotify',  '~> 0.1'
end

gem     'activesupport', '>=  3.0'
gem     'i18n',          '>=  0.5'
