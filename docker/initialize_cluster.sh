#!/bin/sh

leave_swarm_and_init() {
  docker swarm leave --force

  sleep 10

  docker swarm init
}

start_database() {
  echo "Starting database..."
  docker stack deploy --compose-file=docker/1-database.yml dev
  sleep 30
}

apply_migration_and_seeds() {
  echo "Applying migration and seeds..."

  docker service create --name api_migration \
    -e MIX_ENV=dev \
    --restart-condition none \
    --network dev_web sports-app:latest \
    mix do ecto.create, ecto.migrate, run priv/repo/seeds.exs
  sleep 15

  docker service rm api_migration
}

start_application() {
  echo "Starting application..."
  docker stack deploy --compose-file=docker/2-application.yml dev
  sleep 10
}

start_proxy() {
  echo "Starting proxy..."

  creating_config_file

  docker stack deploy --compose-file=docker/3-proxy.yml dev
  sleep 10
}

creating_config_file() {
  cp ./docker/config/haproxy_template.cfg ./docker/config/haproxy.cfg

  grpc_servers=$(docker inspect $(docker ps --filter "name=dev_api*" -q) \
    --format '  server {{index .NetworkSettings.Networks.dev_web.Aliases 0}} {{.NetworkSettings.Networks.dev_web.IPAMConfig.IPv4Address}}:8080 maxconn 32')
  http_servers=$(docker inspect $(docker ps --filter "name=dev_api*" -q) \
    --format '  server {{index .NetworkSettings.Networks.dev_web.Aliases 0}} {{.NetworkSettings.Networks.dev_web.IPAMConfig.IPv4Address}}:4000 maxconn 32')
    

  {
    printf "backend grpc_servers\n";
    printf "  balance roundrobin\n";
    printf "  mode tcp\n";
    printf "%s\n\n" "$grpc_servers";
    printf "backend http_servers\n";
    printf "%s\n\n" "$http_servers";
  } >> docker/config/haproxy.cfg
}

start_instrumentation() {
  echo "Starting prometheus and grafana.."

  cp ./docker/config/prometheus_template.yml ./docker/config/prometheus.yml

  servers="    - targets: $(echo \[$(docker inspect $(docker ps --filter "name=dev_api*" -q) \
    --format "'{{.NetworkSettings.Networks.dev_web.IPAMConfig.IPv4Address}}:4000'")\] | sed -e 's/ /,/g')"

  echo "${servers}" >> docker/config/prometheus.yml

  docker stack deploy --compose-file=docker/4-instrumentation.yml dev

  sleep 10
}

##########################

leave_swarm_and_init
start_database

if [ "$1" = "--with-migration-and-seeds" ]; then
  apply_migration_and_seeds
fi

start_application
start_proxy
start_instrumentation
