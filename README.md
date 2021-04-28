# Установка

1. Клонируй репозиторий:
```git clone git@gitlab.com:niqitos/boilerplate.git```

2. Перейди в катадлог проекта:
```cd boilerplate```

3. Запусти билд:
```make build```

Билд может занять около 10 минут.

4. Создай редирект в /etc/hosts для boilerplate.local

```sudo nano /etc/hosts```

```
127.0.0.1       boilerplate.local
127.0.0.1       api.boilerplate.local
127.0.0.1       admin.boilerplate.local
```

1. Готово! Приложение доступно по ссылке http://boilerplate.local.

Ссылку можно изменить в настройках _/etc/hosts_ твоего компьютера.

В случае возникновения ошибки 502, удостоверся что ```yarn install``` завершился:
```
docker-compose logs node
```


## Makefile

Запуск всех контейнеров docker:
```make up```

Остановка всех контейнеров docker:
```make down```

Посмотреть список всех команд:
```make```


## Laravel

Laravel API доступно по адресу http://api.boilerplate.local/.

Команды artisan доступны через bash alias:
```artisan make:controller HomeController```

[Подробнее об aliases.sh](#Aliases).


## База данных

Для подключения к PostgreSQL через GUI, используй эти параметры:
```
HOST: localhost
PORT: 5432
DB: app
USER: app
PASSWORD: app
```

Подключится к БД через CLI:
```
// Подключись к bash CLI контейнера
docker-compose exec postgres bash
// Затем подключись к DB CLI
psql -U ${POSTGRES_USER} -d ${POSTGRES_DB}
```

**Экспорт**

Выгрузить дамп в _docker/postgres/dumps/dump.sql_:
```
make db-dump
```

**Импорт**

Из _docker/postgres/dumps/_, которая монтируется в папку _/tmp_ внутри контейнера:
```
// Подключись к bash cli контейнера
docker-compose exec postgres bash
// Затем подключись к DB cli
psql -U ${POSTGRES_USER} -d ${POSTGRES_DB} < /tmp/dump.sql
```


## Redis

Подключение к redis CLI:
```
docker-compose exec redis redis-cli
```


## Logs

Все логи **_nginx_** лежат в папке _docker/nginx/logs_.

Все логи **_supervisor_** лежат в папке _docker/supervisor/logs_.

Чтобы посмотреть логи контейнеров docker, используй эти команды:
```
docker-compose logs
docker-compose logs <container>
```

## Clockwork

Подробнее о Clockwork: https://github.com/itsgoingd/clockwork

Для дебага приложения с помощью Clockwork установи расширение для [Chrome](https://chrome.google.com/webstore/detail/clockwork/dmggabnehkmmfmdffgajcflpdjlnoemp) или [Firefox](https://addons.mozilla.org/en-US/firefox/addon/clockwork-dev-tools/)

Clockwork доступен по ссылке http://api.boilerplate.local/__clockwork/app

## Aliases

Алиасы помогают выполнять команды внутри контейнеров проще.

Вместо ```docker-compose exec api php artisan migrate``` можно использовать ```artisan migrate```

Чтобы использовать _/aliases.sh_ запусти:
```
source aliases.sh
```

Все алиасы можно посмотреть в файле _/aliases.sh_


## Переустановка Laravel с нуля

Удали старую папку с Laravel и создай новую:
```
sudo rm -rf api
mkdir api
```

Перезапусти контейнеры docker чтобы перемонтировать новосозданную папку _api_:
```
docker-compose restart
```

Установи Laravel в папку _api_:
```
cd api
docker-compose exec api composer create-project --prefer-dist laravel/laravel .
cd ..
```

Установи права доступа ко всем файлам и папкам сгененрированным пользователем Docker для текущего пользователя:
```
sudo chown ${USER}:${USER} -R api
```

Установи права доступа для Laravel:
```
sudo chmod -R 777 api/bootstrap/cache
sudo chmod -R 777 api/storage
```

Обнови переменные окружения и сгенерируй Laravel application key:
```
sudo rm api/.env
cp .env api/.env
docker-compose exec api php artisan key:generate --ansi
```

Установи redis php client:
```
docker-compose exec api composer require predis/predis
```

Проверь что http://api.boilerplate.local работает.


## Переустановка Nuxt.js:

Удали старую папку с Nuxt и создай новую:

```
sudo rm -rf client
mkdir client
```

Перезапусти контейнеры docker чтобы перемонтировать новосозданную папку _client_:
```
make restart
```

Создай новый проект Nuxt без кастомных серверных фреймворков, с universal rendering mode и с использованием yarn package manager:
```
docker-compose exec node-cli yarn create nuxt-app .
```

Установи права доступа ко всем файлам и папкам сгененрированным пользователем docker для текущего пользователя:
```
sudo chown ${USER}:${USER} -R client
```

Перезапусти контейнеры docker:
```
docker-compose restart
```

Проверь что http://boilerplate.local работает.
