#!/bin/bash

sudo energat -basepower

# Loop from 1 to 20
for ((i=1; i<=20; i++)); do
    # Run Docker container in detached mode with a different name each time
    docker run -d --rm --name "stress-container-$i" alexeiled/stress-ng --cpu 4 --timeout 120s
    
    # Get the PID of the container
    container_pid=$(docker inspect -f '{{.State.Pid}}' "stress-container-$i")
    
    echo "running energat on pid $container_pid"
    # Do something with the PID, for example:
    sudo energat -pid "$container_pid" &  # the & to run it in the background
    # Other operations with $container_pid
    
    # If you want to wait between each iteration, you can add a sleep command here
    # sleep <duration>
done