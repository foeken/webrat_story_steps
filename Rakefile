require 'rubygems'
require 'hoe'
require 'spec'
require 'spec/rake/spectask'
require 'lib/steps/version'

Hoe.new('webrat_story_steps', WebratStorySteps::VERSION) do |p|
  p.rubyforge_name = 'webrat_story_steps'
  p.summary = ''

  p.developer "Andre Foeken",   "andre.foeken@nedap.com"

  p.description = p.paragraphs_of('README.txt', 4..6).join("\n\n")
  p.url = p.paragraphs_of('README.txt', 1).first.split("\n").first.strip
  p.changes = p.paragraphs_of('History.txt', 0..3).join("\n\n")

  p.extra_deps << ["webrat", ">= 0.2"]

  p.remote_rdoc_dir = '' # Release to root
end

