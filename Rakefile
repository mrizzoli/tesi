#############################################################################
#
# Modified version of jekyllrb Rakefile
# https://github.com/jekyll/jekyll/blob/master/Rakefile
#
#############################################################################

require 'rake'
require 'date'
require 'yaml'

CONFIG = YAML.load(File.read('_config.yml'))
USERNAME = CONFIG["username"]
REPO = CONFIG["repo"]
EXTERNAL = "../_site"

# Determine source and destination branch
# User or organization: source -> master
# Project: master -> gh-pages
# Name of source branch for user/organization defaults to "source"
if REPO == "#{USERNAME}.github.io"
  SOURCE_BRANCH = CONFIG['branch'] || "source"
  DESTINATION_BRANCH = "master"
else
  SOURCE_BRANCH = "master"
  DESTINATION_BRANCH = "gh-pages"
end

WORKDIR = Dir.pwd

#############################################################################
#
# Helper functions
#
#############################################################################

def check_destination
  unless Dir.exist? EXTERNAL
    sh "git clone https://#{USERNAME}:#{ENV['GH_TOKEN']}@github.com/#{USERNAME}/#{REPO}.git #{EXTERNAL}"
  end
end

#############################################################################
#
# Post and page tasks
#
#############################################################################


#############################################################################
#
# Site tasks
#
#############################################################################

namespace :site do
  desc "Generate the site and push changes to remote origin"
  task :deploy do
    # Detect pull request
    if ENV['TRAVIS_PULL_REQUEST'].to_s.to_i > 0
      puts 'Pull request detected. Not proceeding with deploy.'
      exit
    end

    # Configure git if this is run in Travis CI
    if ENV["TRAVIS"]
      sh "git config --global user.name 'mrizzoli'"
      sh "git config --global user.email 'marco@rizzoli.me.uk'"
      sh "git config --global push.default simple"
    end

    # Make sure destination folder exists as git repo
    check_destination

    sh "git checkout #{SOURCE_BRANCH}"
    Dir.chdir(EXTERNAL) { sh "git checkout #{DESTINATION_BRANCH}" }

    # Generate the site
    sh "bundle exec jekyll build --trace"

    # Commit and push to github
    sha = `git log`.match(/[a-z0-9]{40}/)[0]
    Dir.chdir(EXTERNAL) do
			sh "rsync -a #{WORKDIR}/_site/* ."
      sh "git add --all ."
      sh "git commit -m 'Updating to #{USERNAME}/#{REPO}@#{sha}.'"
      sh "git push origin #{DESTINATION_BRANCH} --quiet"
      puts "Pushed updated branch #{DESTINATION_BRANCH} to GitHub Pages"
    end
  end
end
