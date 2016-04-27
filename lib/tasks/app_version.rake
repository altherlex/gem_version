
namespace :tagging do
  namespace :app do
    desc "Setting next gem version and push the tag version"
    task :push do
      puts Tagging::AppVersion.increment_and_push
    end

    desc "Setting next gem version and push the tag version"
    task :version do
      puts Tagging::AppVersion.next_version
    end
  end
end
