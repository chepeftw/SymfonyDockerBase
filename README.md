# Symfony Docker Base project

This is a base repository for Symfony projects using Docker. 
Right now it is intended to work with PHP7.0 and Symfony3.x (no particular reason just the latest versions).

Before I explain, I based this project in other repos which are:
- https://github.com/eko/docker-symfony
- https://github.com/maxpou/docker-symfony

Based on this idea I built my own. So to use it I included a cli.sh script for easy usage.

## New project

If you are starting a new project, you need to follow the next steps:

First you need to build the images. This command will be based in the docker-compose.yml file.
```bash
$ bash cli.sh -a build
```

Second you run the images.
```bash
$ bash cli.sh -a start
```

Finally you create the project. The project will be created in the web folder.
```bash
$ bash cli.sh -a new
```

If you have an existing project just omit the "new" command and add your own project to the web folder. 
There are some recommendations for the existing projects that I'll mention in depth later.

Then you can visit http://localhost:8088 to see your working project.

## So what is running???

I have two running modes: 'dev' and 'prod'. The default mode is the PROD environment. 
But if you are a Mac user, and you have some experience in Docker, you should know by now that as far as Docker 1.12 ... there are some performance issues due to IO read and writes to the mac filesystem.
So in this thread they suggested a workaround ... https://forums.docker.com/t/how-to-speed-up-shared-folders/9322/15.
Basically is to create a rsync container, which will speed A LOT the instances (10s to 10ms REALLY!) but you have a sync only in one direction, from your local filesystem to the container filesystem.
So I created a DEV environment, which uses this sync container concept to speed up when you are developing and testing a lot of stuff.

### Dev Environment (Mac users)

To run the dev environment (remember to stop any other instances running in prod environment mode), you can run:

```bash
$ bash cli.sh -a stop
$ bash cli.sh -a build -e dev
$ bash cli.sh -a start -e dev
$ bash cli.sh -a stop -e dev
```

This environment is running:
- db: mysql database. The data of this will go into the data folder in the local filesystem. Remember to customize your password and names in the yml file.
- php: it is a container from PHP7.0 directly. Which basically will process the php files and then conect with nginx to serve the pages.
- ngingx: the webserver. By default is running in 8088, you can change this in the yml.
- elk: a log parser. You can check your logs in http://localhost:83.
- sync: this does the speed up magic for the Mac. I've tried it in Linux and it does not provide major enhancements, so in a Linux you might want to run it in a PROD env mode. Due to this container, everything generated inside the container is kept inside, so if you run generate:bundles or CRUD or something inside the containers will remain there, that is why for creating a new project you need to run in PROD env mode so it copies everything back to the local filesystem, will be slow but it will be really few times so we can live with that.

### Prod Environment (Linux users and Mac users but slow)

To run this just omit the -e flag.

```bash
$ bash cli.sh -a build
$ bash cli.sh -a start
$ bash cli.sh -a stop
```

This environment is running:
- db: mysql database. The data of this will go into the data folder in the local filesystem. Remember to customize your password and names in the yml file.
- php: it is a container from PHP7.0 directly. Which basically will process the php files and then conect with nginx to serve the pages.
- tools: it is a container from PHP7.0 directly with Composer and the Symfony installer. Which works to create a new project, to run composer update or composer install. This can be run in the php container, but the whole point of container is to containerize everything as much as possible so I thought it would be a better idea to have a separate container to run this.
- ngingx: the webserver. By default is running in 8088, you can change this in the yml.

## And that is it???

Other useful commands are:

Clears cache for your symfony application for Symfony dev and prod environments.
```bash
$ bash cli.sh -a cacheclear
```

If you are installing your existing project with this small framework in a new server or new dev machine, you definitely need to install the Symfony vendors, so there is a command for that:
```bash
$ bash cli.sh -a build
$ bash cli.sh -a start
$ bash cli.sh -a install
```

Or you can just update your vendors with:
```bash
$ bash cli.sh -a update
```

## Before you start!!!

Remember to update your parameters.yml file with the correct DB information.
For database_host you can you can use the alias "db".

## Now can I start?!?

Yes, check the files, send me comments, complaints, questions, anything. Share, Contribute and Enjoy :).

