# Commands required to setup working docker enviro, link
# containers etc.
# setup = <<-SH
# Stop and remove any existing containers
# docker stop $(docker ps -a -q)
# docker rm $(docker ps -a -q)

# Build containers from Dockerfiles
# docker build -t postgres /app/docker/postgres
# docker build -t rails /app
# docker build -t redis /app/docker/redis/

# Run and link the containers
# docker run -d --name postgres -e POSTGRESQL_USER=docker -e POSTGRESQL_PASS=docker postgres:latest
# docker run -d --name redis redis:latest
# docker run -d -p 3000:3000 -v /app:/app --link redis:redis --link postgres:db --name rails rails:latest
# SH

# Commands required to ensure correct docker containers
# are started when the vm is rebooted.
# start = <<-SH
# docker start postgres
# docker start redis
# docker start rails
# SH

Vagrant.configure("2") do |config|

  # Setup resource requirements
  config.vm.provider "virtualbox" do |v|
    v.memory  = 2048 # 2Gb
    v.cpus    = 2
  end

  # need a private network for NFS shares to work
  config.vm.network "private_network", ip: "192.168.50.4"

  # Rails Server Port Forwarding
  config.vm.network "forwarded_port", guest: 3000, host: 3000

  # Ubuntu
  config.vm.box = "precise64"

  # Must use NFS for this otherwise rails
  # performance will be awful
  config.vm.synced_folder ".", "/app", type: "nfs"

  # Install latest docker & provision it
  config.vm.provision "docker" do |d|
    # TODO: need to figure out how to run these lines!!
    # d.inline "docker stop $(docker ps -a -q)"
    # d.inline "docker rm $(docker ps -a -q)"

    d.build_image "app/docker/postgres", args: "-t postgres"
    d.build_image "app", args: "-t rails"
    d.build_image "app/docker/redis", args: "-t redis"

    d.run "postgres:latest",
      auto_assign_name: true,
      daemonize:        true,
      args:             "-e POSTGRESQL_USER=docker -e POSTGRESQL_PASS=docker"
    d.run "redis:latest",
      auto_assign_name: true,
      daemonize:        true
    d.run "rails:latest",
      auto_assign_name: true,
      daemonize:        true,
      args:             "-p 3000:3000 -v /app:/app --link redis:redis --link postgres:db"
  end

  # Setup the containers when the VM is first
  # created
  # config.vm.provision "shell", inline: setup

  # Make sure the correct containers are running
  # every time we start the VM.
  config.vm.provision "shell", run: "always",
    inline: "docker start postgres redis rails"
end
