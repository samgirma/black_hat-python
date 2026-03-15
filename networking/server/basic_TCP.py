#!/usr/bin/env python3

import socket
import threading


IP = "0.0.0.0"
port = 8080


def main():
	server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

	try:
		server.bind((IP, port))
		server.listen(5)

		print(f"[*] listen on {IP}:{port}")

		while True:
			client, address = server.accept()
			print(f"[*] Accepted connection from {address[0]}:{address[1]}")
			client_handler = threading.Thread(target=handle_client, args=(client,))
			client_handler.start()

	except KeyboardInterrupt:
		print("\n[*] Server shutting down ....")
	finally:
		server.close()


def handle_client(client_socket):
	with client_socket as sock:
		try:
			request = sock.recv(1024)
			print(f"[*] Recieved: {request.decode('utf-8')}")
			sock.send(b'Request accepted,\nprocessing...\n')

		except Exception as e:
			print(f"[!] Error handling client: {e}")



if __name__ == '__main__':
	main()

