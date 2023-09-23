import socket
import server
import time
import cv2
import numpy as np

if __name__ == '__main__':
    server_buffer_size = server.DEFAULT_BUFFER_SIZE

    server_config = (
            server.DEFAULT_HOST_NAME,
            server.DEFAULT_HOST_PORT
            )

    msg_to_server = str.encode('600 .jpg') #mudei a mensagem anterior para ja mandar o tamanho e formato desejado que ja é aplicado na imagem

    # Create a UDP socket at client side
    client = socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM)

    while (True):
        # Send to server using created UDP socket
        client.sendto(msg_to_server, server_config)

        image_data, msg_from_server  = client.recvfrom(server_buffer_size)
        
        image_array = np.frombuffer(image_data, dtype=np.uint8)
        frame = cv2.imdecode(image_array, cv2.IMREAD_COLOR)
        
        cv2.imshow('Received Image', frame)
        cv2.waitKey(1000)
        
        #msg = "Message from Server {}".format(msgFromServer[0])
        #print(msg_from_server)

cv2.destroyAllWindows()
        


