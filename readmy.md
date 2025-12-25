# https://hub.docker.com/_/mysql#container-shell-access-and-viewing-mysql-logs
# Запустите 
docker-compose up

# Доступ к оболочке контейнера и просмотр журналов MySQL
# Команда docker exec позволяет запускать команды внутри контейнера Docker.
# Следующая командная строка откроет оболочку bash внутри вашего mysql контейнера:
$ docker exec -it some-mysql bash
# Журнал доступен в журнале контейнера Docker:
$ docker-compose logs mysql-db
# Docker работает
docker ps
# Cодержимое
cat .env