#!/bin/bash

sudo energat -basepower

# # Loop from 1 to 20
# for ((i=1; i<=20; i++)); do
#     # Run Docker container in detached mode with a different name each time
#     docker run -d --rm --name "stress-container-$i" alexeiled/stress-ng --cpu 4 --timeout 120s
    
#     # Get the PID of the container
#     container_pid=$(docker inspect -f '{{.State.Pid}}' "stress-container-$i")
    
#     echo "running energat on pid $container_pid"
#     # Do something with the PID, for example:
#     sudo energat -pid "$container_pid" &  # the & to run it in the background
#     # Other operations with $container_pid
    
#     # If you want to wait between each iteration, you can add a sleep command here
#     # sleep <duration>
# done

cpus=(1 2 3 4) 
timeouts=("60s" "90s" "120s" "150s" "180s")

# run 20 docker containers with varying configurations
for cpu in "${cpus[@]}"; do
        for timeout in "${timeouts[@]}"; do
                docker run -d --rm --name "stress-container-cpu$cpu-timeout$timeout" alexeiled/stress-ng --cpu $cpu --timeout $timeout
                container_id=$(docker ps -qf "name=stress-container-cpu$cpu-timeout$timeout")
                container_pid=$(docker inspect --format '{{.State.Pid}}' $container_id)

                echo "stress-container-cpu$cpu-timeout$timeout with continer id: $container_id and container pid: $container_pid"
                sudo energat -pid "$container_pid" > /dev/null 2>&1 &  # output redirected to devnull

                # sudo energat -pid "$container_pid" &  # the & to run it in the background
        done
done