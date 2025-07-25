# history
A simple Blacklight search app for viewing UAlbany history and events

[https://archives.albany.edu/history](https://archives.albany.edu/history)

### For development

Run the app:
```
docker compose up
```

Navigate to [http://localhost:3000/history](http://localhost:3000/history)

You should be able to edit code in real time.

### For deployment

Building the `history` image for production:
```
make build
```

Restarting the service:
```
make restart
```

#### For Windows

These commands don't work on Windows. For that you have to use the full build command:
```
$env:DOCKER_BUILDKIT=1; docker build --secret id=master_key,src=config/master.key -t history .
```

Running the image in the background:
```
docker compose -f docker-compose-prod.yml up -d
```
Navigate to [http://localhost:8081/history](http://localhost:8081/history)

To stop:
```
docker compose down
```

### For a terminal

If you need another terminal:
```
docker exec -it history bash
```