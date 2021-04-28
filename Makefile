.PHONY: help

help:
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

#-----------------------------------------------------------
# Docker
#-----------------------------------------------------------

start: ## Первый запуск
	sudo chmod -R 775 api/bootstrap/cache api/storage
	if [ ! -f api/.env ]; then cp api/.env.example api/.env; fi
	if [ ! -f client/.env ]; then cp client/.env.example client/.env; fi
	if [ ! -f admin/.env ]; then cp admin/.env.example admin/.env; fi
	docker-compose up -d --build
	docker-compose exec api composer install
	docker-compose run --rm client yarn install
	docker-compose run --rm admin yarn install
	docker-compose exec api php artisan key:generate
	docker-compose exec api php artisan jwt:secret
	docker-compose exec api php artisan migrate:fresh --seed
	docker-compose exec api php artisan optimize
	docker-compose exec api php artisan storage:link

build: ## Запустить билд
	docker-compose down
	docker-compose up -d --build
	docker-compose exec api php artisan optimize

up: ## Запустить все контейнеры
	docker-compose up -d

down: ## Остановить все контейнеры
	docker-compose down

restart: ## Перезапустить все контейнеры
	docker-compose down
	docker-compose up -d

---------------: ## ---------------


#-----------------------------------------------------------
# Postgres
#-----------------------------------------------------------

db-dump: ## Дамп базы данных
	docker-compose exec postgres pg_dump -U app -d app > docker/postgres/dumps/dump.sql

---------------: ## ---------------


#-----------------------------------------------------------
# Зависимости
#-----------------------------------------------------------

install: ## Установить зависимости composer и node.js
	docker-compose exec api composer install
	docker-compose run --rm client yarn install
	docker-compose run --rm admin yarn install

update: ## Обновить зависимости composer и node.js
	docker-compose exec api composer update
	docker-compose run --rm client yarn update
	docker-compose run --rm admin yarn update
