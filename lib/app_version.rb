require 'rubygems'
require 'git'
require 'logger'

load File.dirname(__FILE__) + '/tasks/app_version.rake'

module AppVersion
  @@default_commit_message = 'versioning by CI'
  @@version

  def self.next_version
    @@version ||= `git -C #{Dir.pwd} describe --tags $(git -C #{Dir.pwd} for-each-ref refs/tags --sort=-taggerdate --format='%(objectname)' --count=1)`.chomp
    @@version = self.init_version_file unless self.version_format_valid?(@@version)
    @@version
  end

  def self.version_format_valid?(version)
    (version && version =~ /^v\d+\.\d+\.\d+-[\.\d+]+$/)
  end

  def self.init_version_file
    initial_version = 'v0.0.1-00'
  end

  def self.increment_and_push
    self.increment_version
    self.commit_and_push
  end

  def self.increment_version
    self.next_version
  end

  def self.commit_and_push(project_directory = nil, msg = nil, &block)
    g=Git.open(project_directory || Dir.pwd, :log=>Logger.new(STDOUT))
    g.add_tag(self.next_version, nil, message: @@default_commit_message, f: true)
    g.push('origin', "refs/tags/#{self.next_version}", f: true)
  end
end