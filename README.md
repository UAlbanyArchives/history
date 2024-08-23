# history
A simple Blacklight search app for viewing UAlbany history and events

[https://archives.albany.edu/history](https://archives.albany.edu/history)

### For development

Run the app:
```
docker-compose -f docker-compose-dev.yml up
```

Navigate to [http://localhost:3000/history](http://localhost:3000/history)

You should be able to edit code in real time.

When you're done:
```
docker-compose down
```

### For deployment

Building the `history` image:
```
docker build --build-arg MASTER_KEY=$(cat ./config/master.key) -t history .
```

Running the image
```
docker-compose up -d
```
Navigate to [http://localhost:8081/history](http://localhost:8081/history)

To stop:
```
docker-compose down
```

### For a terminal

If you need another terminal:
```
docker exec -it history bash
```