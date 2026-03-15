#!/usr/bin/env python3

''' 
The network is and always will be the sexiest arena
for a hacker.
'''

import socket

target_host="127.0.0.1"
target_port=8080

# create a socket obeject

client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
# AF_INET: This tells the computer to use IPv4 addresses 
# SOCK_STREAM: use TCP connection.


# connect the clinet
client.connect((target_host,target_port))

# Header
header = "GET / HTTP/1.1\r\nHost: google.com\r\n\r\n"
data = '{"username":"samuel","password": 123123}'
# send some data to the server
# encode() | b : network protocol know only bytes so that we changed data to bytes

client.send(data.encode())

response = client.recv(4096)

print(response.decode())

client.close()