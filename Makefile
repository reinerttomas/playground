APP := playground-app

### DOCKER ###

deploy:
	@docker compose -f docker-compose.prod.yaml up --build -d

build:
	@docker compose build

build-up:
	@docker compose up --build -d

up:
	@docker compose up -d

down:
	@docker compose down

clean:
	@docker system prune --all --force

app:
	@docker exec -it $(APP) bash

### COMPOSER ###

composer:
	@docker exec -it $(APP) composer install

### NPM ###

npm:
	@docker exec -it $(APP) npm install

encore-dev:
	@docker exec -it $(APP) npm run dev

encore-build:
	@docker exec -it $(APP) npm run build

### ANALYSIS ###

phpstan:
	@docker exec -e APP_ENV=test -it $(APP) composer phpstan

ccs:
	@docker exec -e APP_ENV=test -it $(APP) composer ccs

fcs:
	@docker exec -e APP_ENV=test -it $(APP) composer fcs

### TESTING ###

test:
	@docker exec -e APP_ENV=test -it $(APP) composer test-full

ci:
	@docker exec -e APP_ENV=test -it $(APP) composer ci
