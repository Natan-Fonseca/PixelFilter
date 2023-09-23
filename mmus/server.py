# https://pythontic.com/modules/socket/udp-client-server-example

import socket
import cv2
import numpy as np
import image
import video

DEFAULT_BUFFER_SIZE = 1024000
DEFAULT_HOST_NAME = '127.0.0.1'
DEFAULT_HOST_PORT = 80
DEFAULT_IMAGE_PATH = 'godot.png' 

class ConfigurationStreamServer:
    def __init__(self, host, port, bf_size):
        self.config = f'host: {host}, port: {port}, buffer_size: {bf_size}'
        self.requisition = 0
    
    def __iter__(self):
        return self

    def __next__(self):
        self.requisition += 1
        message = f'{self.config}, requisition:{self.requisition}'

        return str.encode(message)                                  

def prepare_server(host, port):
    # Create a datagram socket
    server = socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM)
    
    # Bind to address and ip
    server.bind((host, port))

    return server

def run_server(server, stream, bf_size):
    # Listen for incoming datagrams   
    while (True):
        msg, addr = server.recvfrom(bf_size)
        
        stream.configure_stream(msg) #unica mudança feita no server
        
        server.sendto(next(stream), addr)

if __name__ == '__main__':
    buffer_size = DEFAULT_BUFFER_SIZE
    host_name, host_port = DEFAULT_HOST_NAME, DEFAULT_HOST_PORT
    image_path = DEFAULT_IMAGE_PATH
    
    stream = image.ImageStreamServer(image_path)
    server = prepare_server(host_name, host_port)
    run_server(server, stream, buffer_size)

