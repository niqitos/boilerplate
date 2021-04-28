# Выполнить команду в контейнере
alias exec='docker-compose exec'

# Запустить команды artisan
alias art='docker-compose exec api php artisan'
alias artisan='docker-compose exec api php artisan'

# Запустить команды composer
alias composer='docker-compose exec api composer'

# Запустить команды yarn для клиента
alias client:yarn='docker-compose run --rm client yarn'
alias admin:yarn='docker-compose run --rm admin yarn'

alias up='docker-compose up -d'
alias down='docker-compose down'

# phpunit
alias phpunit='docker-compose exec api vendor/bin/phpunit'
alias phpunit:f='docker-compose exec api vendor/bin/phpunit --filter'
alias phpunit:fc='docker-compose exec api vendor/bin/phpunit  --coverage-html tests/report --filter'

alias php-fpm='docker-compose exec php-fpm'
alias postgres='docker-compose exec postgres'

# Логи Docker
alias dlogs='docker-compose logs'
alias dlogs:clear='sudo rm -v docker/nginx/logs/*.log docker/supervisor/logs/*.log'

# Алиасы Docker
alias ps='docker-compose ps'
