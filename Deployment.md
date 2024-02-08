### How To Setup App

1. Copy .env-example to .env
2. Change DB{HOST, DATABASE, USERNAME, PASSWORD}
3. Build App
```bash
docker compose build app
```
4. Run Docker compose
```bash
docker compose up -d
```
5. Check Container
```bash
docker compose ps
docker compose exec app ls -l
```
6. Reset App
```bash
docker compose exec app rm -rf vendor composer.lock
docker compose exec app composer install
```
7. Generate Key Laravel
```bash
docker compose exec app php artisan key:generate
```
8. Migration, Seeder, Database
```bash
docker compose exec app php artisan migrate:refresh --seed
```

#### Method 2

1. Update Add Repository

```bash
sudo apt install software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt update
```

2. Install Php 7.4

```bash
sudo apt-get install php7.4 php7.4-fpm

sudo apt-get install php7.4-mysql php7.4-mbstring php7.4-xml php7.4-gd php7.4-curl

curl -sS https://getcomposer.org/installer | php
php composer.phar update
```

3. Build Image

```bash
docker build -t nomads:v1 . -f Dockerfile.dock
```

4. Run Container

```bash
docker run -d -p 8000:8000 --name nomads-app nomads:v1
```



