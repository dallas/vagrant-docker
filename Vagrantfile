unless ARGV.include?("--no-parallel")
  raise "must run with the --no-parallel option!"
end

ENV["VAGRANT_DEFAULT_PROVIDER"] = "docker"
DOCKER_HOST_NAME                = "docker-host"
DOCKER_HOST_VAGRANTFILE         = "./docker/Vagrantfile"

# Be sure to call `vagrant up` with the `--no-parallel` option!
Vagrant.configure("2") do |config|

  config.vm.define :db do |db|
    db.vm.provider :docker do |d|
      d.vagrant_machine     = DOCKER_HOST_NAME
      d.vagrant_vagrantfile = DOCKER_HOST_VAGRANTFILE

      d.image               = "postgres:latest"
      d.name                = "postgres"
      d.env                 = {
        "POSTGRES_USER"       => "new_vagrant_docker",
        "POSTGRES_PASSWORD"   => "c85ZDjUkpql1"
      }
      d.remains_running     = true
    end
  end

  config.vm.define :app do |app|
    app.vm.synced_folder ".", "/app", type: "nfs"

    app.vm.provider :docker do |d|
      d.vagrant_machine     = DOCKER_HOST_NAME
      d.vagrant_vagrantfile = DOCKER_HOST_VAGRANTFILE

      d.build_dir           = "."
      d.build_args          = ["-t", "rails"]
      d.name                = "rails"
      d.link                  "postgres:db"
      d.env                 = {
        "RAILS_ENV"           => "development"
      }
      d.ports               = ["3000:3000"]
      d.remains_running     = true
    end
  end
end
