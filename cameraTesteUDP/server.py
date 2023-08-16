
# This is server code to send video frames over UDP
import cv2, imutils, socket
import numpy as np
import time
import base64

BUFF_SIZE = 65536
server_socket = socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
server_socket.setsockopt(socket.SOL_SOCKET,socket.SO_RCVBUF,BUFF_SIZE)
host_name = socket.gethostname()
host_ip = '127.0.0.1'#  socket.gethostbyname(host_name)
print(host_ip)
port = 9999
socket_address = (host_ip,port)
server_socket.bind(socket_address)
print('Listening at:',socket_address)

vid = cv2.VideoCapture(0) 
fps,st,frames_to_count,cnt = (0,0,20,0)

#Processo simplificado(Sem mostrar o vídeo na tela)por enquanto incompleto

# while True: 
# 	msg,client_addr = server_socket.recvfrom(BUFF_SIZE)
# 	if not vid.isOpened():
# 			sys.exit('Video source not found...')


# 	ret, frame = vid.read()

# 	frame = imutils.resize(frame, width=400)

# 	#Send frame to Godot
# 	#this is based on a python to python UDP video stream tutorial I found at 
# 	#https://pyshine.com/Send-video-over-UDP-socket-in-Python/

# 	encode, buffer = cv2.imencode('.jpg', frame, [cv2.IMWRITE_JPEG_QUALITY,80])
# 	server_socket.sendto(bytes(buffer),client_addr)


# #Send frame to Godot
# #this is based on a python to python UDP video stream tutorial I found at 
#https://pyshine.com/Send-video-over-UDP-socket-in-Python/

#Por enquanto usar esse método
while True:
	msg,client_addr = server_socket.recvfrom(BUFF_SIZE) #client_addr é necessario
	print('GOT connection from ',client_addr)
	while(vid.isOpened()):
		ret, frame = vid.read()
		frame = imutils.resize(frame, width=400)
		encode, buffer = cv2.imencode('.jpg', frame, [cv2.IMWRITE_JPEG_QUALITY,80])
		#message = base64.b64encode(buffer) #No fórum que estudei, ele fala pra não usar encode
		server_socket.sendto(bytes(buffer),client_addr) # se fizer a conexão de outra forma, a godot não conecta, não entendi
		frame = cv2.putText(frame,'FPS: '+str(fps),(10,40),cv2.FONT_HERSHEY_SIMPLEX,0.7,(0,0,255),2)
		cv2.imshow('TRANSMITTING VIDEO',frame)
		key = cv2.waitKey(1) & 0xFF
		if key == ord('q'):
			server_socket.close()
			break
		if cnt == frames_to_count:
			try:
				fps = round(frames_to_count/(time.time()-st))
				st=time.time()
				cnt=0
			except:
				pass
		cnt+=1

