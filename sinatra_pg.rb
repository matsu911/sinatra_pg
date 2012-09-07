#!/usr/bin/env ruby

@project_name = ARGV[0]

raise "#{@project_name} already exists" if File.exists? @project_name

Dir.mkdir @project_name
Dir.mkdir File.join @project_name, "test"
Dir.mkdir File.join @project_name, "public"
Dir.mkdir File.join @project_name, "views"

def file(name)
  File.open(File.join(@project_name, name), "w") do |f|
    f.write(yield)
  end
end

file "app.rb" do
  "require 'sinatra'

get '/' do
  'Hello World!'
end
"
end

file "Gemfile" do
  "gem 'sinatra'
"
end

file "config.ru" do
  "require './app'

use Rack::Lint
run Sinatra::Application
"
end

file ".gitignore" do
  "*~
"
end

file "Rakefile" do
  "require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.libs << '.'
  t.test_files = FileList['test/**/tc_*.rb']
end
"
end
