
namespace :tagging do
  desc "Setting next gem version and push the tag version"
  task :push do
    puts AppVersion.increment_and_push
  end

  desc "Setting next gem version and push the tag version"
  task :version do
    puts GemVersion.next_version
  end
end
