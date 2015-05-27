# For Bundler.with_clean_env
require 'bundler/setup'

PACKAGE_NAME = "uaac-standalone"
VERSION = "3.1.0"
TRAVELING_RUBY_VERSION = "20150517-2.2.2"

GEM_EVENTMACHINE = "eventmachine-1.0.6"     # Must match Gemfile
GEM_HTTPPARSER   = "http_parser.rb-0.6.0"  # Must match Gemfile


desc "Package your app"
task :package => ['package:linux:x86_64']

namespace :package do
  namespace :linux do
    desc "Package your app for Linux x86_64"
    task :x86_64 => [:bundle_install,
        "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86_64.tar.gz",
        "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86_64-#{GEM_EVENTMACHINE}.tar.gz",
        "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86_64-#{GEM_HTTPPARSER}.tar.gz"
      ] do
      create_package("linux-x86_64")
    end
  end

  desc "Install gems to local directory"
  task :bundle_install do
    if RUBY_VERSION !~ /^2\.2\./
      abort "You can only 'bundle install' using Ruby 2.2, because that's what Traveling Ruby uses."
    end
    sh "rm -rf packaging/tmp"
    sh "mkdir packaging/tmp"
    sh "cp packaging/Gemfile packaging/tmp/"
    Bundler.with_clean_env do
      sh "cd packaging/tmp && env BUNDLE_IGNORE_CONFIG=1 bundle install --path ../vendor --without development"
    end
    sh "rm -rf packaging/tmp"
    sh "rm -f packaging/vendor/*/*/cache/*"

    if !ENV['KEEP_EXT']
      # Remove native extensions
      sh "rm -rf packaging/vendor/ruby/*/extensions"
      sh "find packaging/vendor/ruby/*/gems -name '*.so' | xargs rm -f"
      sh "find packaging/vendor/ruby/*/gems -name '*.bundle' | xargs rm -f"
      sh "find packaging/vendor/ruby/*/gems -name '*.o' | xargs rm -f"
    end
  end
end

file "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86_64.tar.gz" do
  download_runtime("linux-x86_64")
end


file "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86_64-#{GEM_EVENTMACHINE}.tar.gz" do
  download_native_extension("linux-x86_64", "#{GEM_EVENTMACHINE}")
end

file "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86_64-#{GEM_HTTPPARSER}.tar.gz" do
  download_native_extension("linux-x86_64", "#{GEM_HTTPPARSER}")
end

def create_package(target)
  package_dir = "#{PACKAGE_NAME}-#{VERSION}-#{target}"
  sh "rm -rf #{package_dir}"
  sh "mkdir -p #{package_dir}"
  sh "mkdir -p #{package_dir}/lib/ruby"
  sh "tar -xzf packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-#{target}.tar.gz -C #{package_dir}/lib/ruby"
  sh "cp packaging/uaac #{package_dir}/"
  sh "cp -pR packaging/vendor #{package_dir}/lib/"
  sh "cp packaging/Gemfile Gemfile.lock #{package_dir}/lib/vendor/"
  sh "mkdir -p #{package_dir}/lib/vendor/.bundle"
  sh "cp packaging/bundler-config #{package_dir}/lib/vendor/.bundle/config"

  sh "tar -xzf packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-#{target}-#{GEM_EVENTMACHINE}.tar.gz " +
    "-C #{package_dir}/lib/vendor/ruby"

  sh "tar -xzf packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-#{target}-#{GEM_HTTPPARSER}.tar.gz " +
    "-C #{package_dir}/lib/vendor/ruby"

  if !ENV['DIR_ONLY']
    sh "tar -czf #{package_dir}.tar.gz #{package_dir}"
    sh "rm -rf #{package_dir}"
  end
end

def download_runtime(target)
  sh "cd packaging && curl -L -O --fail " +
    "https://s3.amazonaws.com/ruby-traveler-packages/#{TRAVELING_RUBY_VERSION}/#{target}/traveling-ruby-#{TRAVELING_RUBY_VERSION}-#{target}.tar.gz"
end

def download_native_extension(target, gem_name_and_version)
  sh "curl -L --fail -o packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-#{target}-#{gem_name_and_version}.tar.gz " +
     "https://s3.amazonaws.com/ruby-traveler-packages/#{TRAVELING_RUBY_VERSION}/#{target}/traveling-ruby-#{TRAVELING_RUBY_VERSION}-#{target}-#{gem_name_and_version}.tar.gz"
end
