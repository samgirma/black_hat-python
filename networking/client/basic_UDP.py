# !/usr/bin/env python3

import socket

target_host = "127.0.0.1"
target_port = 8080

# creating socket object

client = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

# send some data
data = "Hollo server!"

client.sendto(data.encode(), (target_host,target_port))

# recieve some data

output_data, addr = client.recvfrom(4096)
# 4096 repsenet the buffer size of recieved data would be 4kb

print(output_data.decode())
client.close()

