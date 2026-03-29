# Oracle Cloud Always Free Deployment

This project is prepared to run 24/7 on an Oracle Cloud Always Free VM using Docker and SQLite.

## Why this option

- Oracle's Always Free resources are documented as never expiring.
- The app can run on one VM without a paid database.
- Free PaaS options usually sleep or have Laravel limitations.

## 1. Create the VM

Create an Always Free Ubuntu VM in your Oracle home region. Open inbound port `80` in the VCN security list and instance firewall.

## 2. Install Docker on the VM

```bash
sudo apt update
sudo apt install -y ca-certificates curl git
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker $USER
newgrp docker
docker --version
docker compose version
```

## 3. Pull the project

```bash
git clone https://github.com/gdkd29208-cpu/nabdNews.git
cd nabdNews
```

## 4. Create the Oracle production env

```bash
mkdir -p deploy/oracle
cp deploy/oracle/.env.oracle.example deploy/oracle/.env.oracle
```

Edit `deploy/oracle/.env.oracle` and set:

- `APP_KEY`
- `APP_URL`
- `ADMIN_REGISTRATION_SECRET`

Generate a Laravel key if you need one:

```bash
php -r "echo 'base64:'.base64_encode(random_bytes(32)).PHP_EOL;"
```

Use your VM public IP in `APP_URL`, for example:

```env
APP_URL=http://123.123.123.123
```

## 5. Start the app

```bash
docker compose -f docker-compose.oracle.yml up -d --build
```

## 6. Open the website

Visit:

```text
http://YOUR_SERVER_PUBLIC_IP
```

## Useful commands

View logs:

```bash
docker compose -f docker-compose.oracle.yml logs -f
```

Restart after changes:

```bash
git pull
docker compose -f docker-compose.oracle.yml up -d --build
```

Stop:

```bash
docker compose -f docker-compose.oracle.yml down
```
