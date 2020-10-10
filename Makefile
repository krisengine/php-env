VERSION_PHP_APPLICATION = $(shell cat VERSION-PHP-APPLICATION)
VERSION_WEBSERVER = $(shell cat VERSION-WEBSERVER)

default: build

build: build-php push-nginx

push: push-php build-nginx

build-php:
	docker build -t krisengine/php-application:$(VERSION_PHP_APPLICATION) -f Dockerfile-php-application .
	docker build -t krisengine/php-application:latest -f Dockerfile-php-application .

push-php: build-php
	docker push krisengine/php-application:$(VERSION_PHP_APPLICATION)
	docker push krisengine/php-application:latest

build-nginx:
	docker build -t krisengine/webserver:$(VERSION_WEBSERVER) -f Dockerfile-webserver .
	docker build -t krisengine/webserver:latest -f Dockerfile-webserver .

push-nginx: build-nginx
	docker push krisengine/webserver:$(VERSION_WEBSERVER)
	docker push krisengine/webserver:latest

build-php-test:
	docker build -t krisengine/php-application-test:$(VERSION_PHP_APPLICATION) -f Dockerfile-test .
	docker build -t krisengine/php-application-test:latest -f Dockerfile-test .

push-php-test: build-php-test
	docker push krisengine/php-application-test:$(VERSION_PHP_APPLICATION)
	docker push krisengine/php-application-test:latest

up-network:
	docker network create appnet

down-network:
	docker network rm appnet

run-nginx: build-nginx
	docker run -p 80:80 --network appnet -i krisengine/webserver:latest

run-php:
	docker run -p 9000:9000 --network appnet -i krisengine/php-application:latest

run-test:
	docker build -t php-test:latest -f Dockerfile-test .
	docker run -p 9000:9000 --network appnet --name=fpm -i php-test:latest
