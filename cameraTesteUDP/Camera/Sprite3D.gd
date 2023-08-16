class_name ClientNode
extends Node

var udp := PacketPeerUDP.new()
var connected = false

func _ready():
	udp.connect_to_host("127.0.0.1", 9999)

func _process(delta):
	if !connected:
		# Try to contact server
		udp.put_packet("The answer is... 42!".to_utf8())
	if udp.get_available_packet_count() > 0:
		print("Connected: %s" % udp.get_packet())
		connected = true
		
		
# wait for input to request an image from server
var peerpacket = udp.get_packet()
var cam1texture = create_texture_from_pool_byte_array(peerpacket)

func create_texture_from_pool_byte_array(byte_array):
	var im = Image.new()
	im.load_jpg_from_buffer(byte_array)   #<- Point of issue
	var im_tx = ImageTexture.new()
	im_tx.create_from_image(im)
	return im_tx	

# returning image data
