# Nginx variables
nginx_dir       = "_nginx"
public_dir      = "public"    # compiled site directory
deploy_branch  = "master"


desc "deploy basic rack app to nginx server"
  multitask :nginx do
    puts "## Deploying to nginx server"
    (Dir["#{nginx_dir}/www/*"]).each { |f| rm_rf(f) }
    system "cp -R #{public_dir}/* #{nginx_dir}/www"
    puts "\n## copying #{public_dir} to #{nginx_dir}/www"
    cd "#{nginx_dir}" do
      system "git add ."
      system "git add -u"
      puts "\n## Committing: Site updated at #{Time.now.utc}"
      message = "Site updated at #{Time.now.utc}"
      system "git commit -m '#{message}'"
      puts "\n## Pushing generated #{nginx_dir} website"
      system "git push heroku #{deploy_branch}"
      puts "\n## Heroku deploy complete"
    end
  end
