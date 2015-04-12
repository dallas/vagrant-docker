if ARGV[0] == "up" && !ARGV.include?("--no-parallel")
  raise "must run with the --no-parallel option!"
end

ENV["VAGRANT_DEFAULT_PROVIDER"] = "docker"
DOCKER_HOST_HOME                = ENV["DOCKER_HOST_HOME"] || "~/vagrant/docker-host"
DOCKER_HOST_NAME                = "docker-host"
DOCKER_HOST_VAGRANTFILE         = File.expand_path(File.join(DOCKER_HOST_HOME, "Vagrantfile"))
APP_NAME                        = "vagrant-docker"

# Be sure to call `vagrant up` with the `--no-parallel` option!
Vagrant.configure("2") do |config|

  config.vm.define "#{APP_NAME}_db" do |db|
    db.vm.provider :docker do |d|
      d.vagrant_machine     = DOCKER_HOST_NAME
      d.vagrant_vagrantfile = DOCKER_HOST_VAGRANTFILE

      d.image               = "postgres:latest"
      d.name                = "#{APP_NAME}_postgres"
      d.env                 = {
        "POSTGRES_USER"       => APP_NAME,
        "POSTGRES_PASSWORD"   => "c85ZDjUkpql1"
      }
      d.remains_running     = true
    end
  end

  config.vm.define "#{APP_NAME}_rails" do |app|
    app.vm.synced_folder ".", "/app", type: "nfs"

    app.vm.provider :docker do |d|
      d.vagrant_machine     = DOCKER_HOST_NAME
      d.vagrant_vagrantfile = DOCKER_HOST_VAGRANTFILE

      d.build_dir           = "."
      d.name                = "#{APP_NAME}_rails"
      d.link                  "#{APP_NAME}_postgres:db"
      d.env                 = {
        "RAILS_ENV"           => "development"
      }
      d.ports               = ["3000:3000"]
      d.remains_running     = true
    end
  end
end
