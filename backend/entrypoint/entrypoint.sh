#!/bin/bash
set -e

echo "Laravel"
echo "supervisord конфиг"
cp /var/www/html/supervisord/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

mkdir -p /var/www/html/storage/framework/{sessions,views,cache}
mkdir -p /var/www/html/bootstrap/cache
mkdir -p /var/www/html/storage/logs

chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

if [ ! -f /var/www/html/.env ]; then
    cp .env.example .env
    echo "Создан .env"
fi

echo "MySQL"
while ! nc -z mysql-db 3306; do
  sleep 1
done
echo "MySQL доступена"

echo "Redis"
while ! nc -z redis-db 6379; do
  sleep 1
done
echo "Redis доступена"

echo "RabbitMQ"
while ! nc -z rabbitmq 5672; do
  sleep 1
done
echo "RabbitMQ доступен"

if [ ! -d /var/www/html/vendor ] || [ ! -f /var/www/html/vendor/autoload.php ]; then
    echo "Установка Composer"
    composer install --no-dev --optimize-autoloader
fi

echo "Настройка Laravel..."
php artisan storage:link
php artisan key:generate
php artisan migrate --force

echo "Laravel приложение готово!"
echo "Запуск PHP-FPM и Queue Worker через Supervisord..."

# Запускаем Supervisord
exec "$@"
