require 'rubygems'
require 'git'
require 'logger'

# load File.dirname(__FILE__) + '/tasks/gem_version.rake'
#require './lib/app_version.rb'
#AppVersion.increment_version
#AppVersion.next_version

module AppVersion
  @@gem_version_file = '.version'
  @@default_commit_message = 'versioning by CI'
  @@version

  def self.gem_version_file=(str)
    @@gem_version_file = str
  end

  def self.next_version
    # init_version_file unless File.exist?(@@gem_version_file)
    # file = File.new(@@gem_version_file, 'r')
    # version = file.gets.chomp
    # raise "#{@@gem_version_file} file corrupt" unless self.version_format_valid?(version)
    # file.close
    # version
    @@version ||= `git -C #{Dir.pwd} describe --tags $(git -C #{Dir.pwd} for-each-ref refs/tags --sort=-taggerdate --format='%(objectname)' --count=1)`.chomp
    @@version = self.init_version_file unless self.version_format_valid?(@@version)
    @@version
  end

  # def self.set_version(version)
  #   raise "Invalid version format" unless self.version_format_valid?(version)
  #   update_version(version)
  # end
  
  def self.version_format_valid?(version)
    (version && version =~ /^v\d+\.\d+\.\d+-[\.\d+]+$/)
  end

  def self.init_version_file
    initial_version = 'v0.0.1-00'
    # file = File.new(@@gem_version_file, 'w')
    # file.puts initial_version
    # file.close
  end

  def self.increment_and_push
    self.increment_version
    self.commit_and_push
  end

  def self.increment_version
    self.next_version
  #   version = self.next_version
  #   # components = version.split('.')
  #   # components.push((components.pop.to_i + 1).to_s)
  #   # new_version = components.join('.')
  #   new_version = version.next
  #   # update_version(new_version)
  #   version
  end

  # def self.update_version(new_version)
  #   file = File.new(@@gem_version_file, 'w')
  #   file.puts new_version
  #   file.close    
  # end

  def self.commit_and_push(project_directory = nil, msg = nil, &block)
    g=Git.open(project_directory || Dir.pwd, :log=>Logger.new(STDOUT))
    # g.add(@@gem_version_file)
    # yield(g) if block_given?
    # g.commit(msg || @@default_commit_message)
    # g.push
    
    # git for-each-ref refs/tags --sort=-taggerdate --format='%(refname)' --count=1
    # git describe --tags $(git rev-list --tags --max-count=1)
    # git describe --tags $(git for-each-ref refs/tags --sort=-taggerdate --format='%(objectname)' --count=1)
    # a = `git describe --tags \`git rev-list --tags --max-count=1\``.chomp

    g.add_tag(self.next_version, nil, message: @@default_commit_message, f: true)

    g.push('origin', "refs/tags/#{self.next_version}", f: true)
  end
end