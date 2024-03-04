# RabbitMQ Test

This project was built as a test to learn about RabbitMQ and how to use it with rails

## How to run it locally

The project is set up to run using docker images for developments and docker compose to build the full server. This are the main commands to run the project.

### Run the full project
```bash
docker compose up
```

### Prepare the database for the app
This command will drop the whole database and create a new one, if you only want to run
the migrations just remove the reset part of the task
```bash
docker compose run app rails db:migrate:reset
```

### Run the interactive console  inside the Rails container
Remember that the name of the container for the app declared in the compose file
is app, if you modified it you have to change the name of the container in the commands
```bash
docker exec -it app sh
```
```bash
docker exec -it app /bin/bash
```

### Shutdown the project
```bash
docker compose down
```

### List containers
```bash
docker container ls
```

### Delete containers
```bash
docker container rm <container_id>
```

### List images
```bash
docker image ls
```

### Remove images
```bash
docker image rm <image_name>
```

### RabbitMQ Admin Interface
After the application is running just go to [localhost](http://localhost:15672) and the login page for it should show.

## Technical stuff
- Ruby Version: **3.1.2**
- Rails Version: **7.1.3**
- Bunny Version: **2.22.0**
- Database Engine: **Postgresql**
- Database Engine Version: **14**
- RabbitMQ Image: **rabbitmq:3.13-rc-management-alpine**

## Authors

👤 **Mateo mojica**

- Github: [@mateomh](https://github.com/mateomh)
- Medium: [@mateo-mojica](https://medium.com/@mateo-mojica)
- Linkedin: [Mateo mojica](https://linkedin.com/mateo_mojica_hernandez)


## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

Feel free to check the [issues page](issues/).

## Show your support

Give a ⭐️ if you like this project!
