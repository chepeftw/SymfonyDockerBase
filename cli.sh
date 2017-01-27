#!/bin/bash
# Use -gt 1 to consume two arguments per pass in the loop (e.g. each
# argument has a corresponding value to go with it).
# Use -gt 0 to consume one or more arguments per pass in the loop (e.g.
# some arguments don't have a corresponding value to go with it such
# as in the --default example).

S='docker-compose.yml'

# Cache Clear
# This functions first deletes all files from var/cache symfony directory.
# Then it deletes the same folders in the containers.
# If this fails, it creates the folders just in case and assign them 777 permission.
# Then runs symfony cache clear, which up to this point is redundant, I know, but
# the cache clear will generate some files.
# Finally it assings permissions 777 to make sure.
function sf_cacheclear {
    rm -rf web/var/cache/dev/* web/var/cache/prod/*
    docker-compose exec php rm -rf /var/www/symfony/var/logs/* /var/www/symfony/var/cache/dev/* /var/www/symfony/var/cache/prod/*
    docker-compose exec php mkdir -p /var/www/symfony/var/logs /var/www/symfony/var/cache /var/www/symfony/web/uploads
    docker-compose exec php chmod -R 777 /var/www/symfony/var /var/www/symfony/web/uploads

    docker-compose exec php bin/console cache:clear --env=prod
    docker-compose exec php bin/console cache:clear
    docker-compose exec php chmod -R 777 /var/www/symfony/var
}

# Composer
# This function is either to update or install the symfony project,
# ASSUMING is an existing project but it is being instantiated in a new
# location, like a server or new dev machine.
function sf_composer {
    docker-compose exec tools composer $1
}

# New SF Project
# This command can only be run using the PROD environment.
# This is because the dev environment is intended to use the sync container,
# and this container copies from local FS (L_FS) to the container FS (C_FS), 
# but not from C_FS to L_FS, so everything that is created inside the container
# stays in the container and this case we want it to be copied back tot he LF_FS.
function sf_new {
    mkdir web
    rm -rf web/var
    docker-compose exec tools symfony new /var/www/symfony
}

# Docker Build, Start and Stop
# This 3 functions will heavily rely on docker-compose and the yml compose conf file.
# The intention is to build, start or stop the instances.
# The start function, not only start the docker infrastructure, but also assigns some
# permissions to some nginx folder that caused me problems in the past.
# Lastly it updates symfony schema.
function dock_build {
    docker-compose -f $S build
}

function dock_start {
    docker-compose -f $S up -d

    docker-compose exec nginx mkdir -p /var/lib/nginx/tmp/client_body
    docker-compose exec nginx chown -R www-data:www-data /var/lib/nginx /var/lib/nginx/tmp /var/lib/nginx/tmp/client_body
    docker-compose exec nginx chmod -R 777 /var/lib/nginx/tmp/client_body /var/lib/nginx/tmp /var/lib/nginx

    docker-compose exec php bin/console doctrine:schema:update --dump-sql --force
}

function dock_stop {
    docker-compose -f $S stop
}

while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -e|--environment)
        ENV="$2"
        shift # past argument
    ;;
    -a|--action)
        ACTION="$2"
        shift # past argument
    ;;
    *)
        # unknown option
    ;;
esac
shift # past argument or value
done


if [ "$ENV" == "dev" ];
then
    echo "Dev ..."
    S='docker-compose.dev.yml'
fi


case "$ACTION" in
    start)
        dock_start
        ;;
     
    stop)
        dock_stop
        ;;
     
    build)
        dock_build
        ;;

    run)
        dock_build
        dock_start
        ;;

    cacheclear)
        sf_cacheclear
        ;;

    install)
        sf_composer install
        ;;
     
    update)
        sf_composer update
        ;;

    new)
        sf_new
        ;;

    *)
        echo $"Usage: $0 {start|stop|build|run|cacheclear|install|update}"
        exit 1
esac
