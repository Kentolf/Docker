Проект:
Отчет по лабораторной

docker-compose.yml, где описаны два сервиса: redis (хранит значение счётчика) и rocketcounter (показывает страницу с кнопкой GET A ROCKET)

Зависимости:  
Docker Desktop с Linux containers и Docker Compose. Git для клонирования репозитория

Команды запуска:

```
git clone https://github.com/Kentolf/Docker.git
cd Docker\lab3
docker compose up -d --scale rocketcounter=2
docker compose ps
```

Где:  
up -d - запускаем стек 
--scale rocketcounter=2 - запускаем две копии приложения с одним общим Redis
ps - смотрим контейнеры и опубликованные порты

Вывод docker compose ps:

```
NAME                   STATUS         PORTS
lab3-redis-1           Up 2 seconds   6379/tcp
lab3-rocketcounter-1   Up 1 second    0.0.0.0:32769->5000/tcp, [::]:32769->5000/tcp
lab3-rocketcounter-2   Up 2 seconds   0.0.0.0:32768->5000/tcp, [::]:32768->5000/tcp
```

Остановка и удаление:

```
docker compose down -v
```

Команда удаляет контейнеры и сеть проекта, а -v также удаляет его тома
