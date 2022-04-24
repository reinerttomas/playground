CONTAINER_NAME := playground-php

### DOCKER ###

build:
	@docker compose build

up:
	@docker compose up -d

down:
	@docker compose down

clean:
	@docker system prune --all --force

php:
	@docker exec -it $(CONTAINER_NAME) sh

### COMPOSER ###

composer:
	@docker exec -it $(CONTAINER_NAME) composer install

### NPM ###

npm:
	@docker exec -it $(CONTAINER_NAME) npm install

encore-dev:
	@docker exec -it $(CONTAINER_NAME) npm run dev

encore-build:
	@docker exec -it $(CONTAINER_NAME) npm run build

### ANALYSIS ###

phpstan:
	@docker exec -e APP_ENV=test -it $(CONTAINER_NAME) composer phpstan

ccs:
	@docker exec -e APP_ENV=test -it $(CONTAINER_NAME) composer ccs

fcs:
	@docker exec -e APP_ENV=test -it $(CONTAINER_NAME) composer fcs

### TESTING ###

test:
	@docker exec -e APP_ENV=test -it $(CONTAINER_NAME) composer test-full

ci:
	@docker exec -e APP_ENV=test -it $(CONTAINER_NAME) composer ci
