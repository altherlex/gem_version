
namespace :gem do
  desc "Clean *.gem* files from project root"
  task :clean do
    FileUtils.rm_f Dir.glob('*.gem*')
  end

  desc "Return and set next gem version"
  task :version do
    if (ENV.include?("set"))
      version = ENV['set'].gsub(/'/, '')
      unless GemVersion.version_format_valid?(version)
        raise "Version '#{version}' format invalid.  Must only contain digits separated by decimal points."
      end
      GemVersion.set_version(version)
      puts "Next version set at '#{version}'"
    else
      puts GemVersion.next_version
    end
  end
end
