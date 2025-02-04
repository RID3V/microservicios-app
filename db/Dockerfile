FROM mysql:8.0.33

ENV MYSQL_ROOT_PASSWORD="vprodbpass"
ENV MYSQL_DATABASE="accounts"


RUN curl -o /docker-entrypoint-initdb.d/backup.sql https://raw.githubusercontent.com/hkhcoder/vprofile-project/refs/heads/docker/src/main/resources/db_backup.sql
