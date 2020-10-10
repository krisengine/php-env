# Окружение для запуска PHP проектов в kubernetes

## Пример докер файла

```
FROM krisengine/php-application:latest
COPY ./index.php /var/www/public/index.php
```

## Пример докер деплоймента

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: env-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: env-app
  template:
    metadata:
      labels:
        app: env-app
    spec:
      containers:
        - name: php-fpm
          image: krisengine/php-application-test:v4
          ports:
            - containerPort: 9000
        - name: webserver
          image: krisengine/webserver:v7
          ports:
            - containerPort: 80
```

