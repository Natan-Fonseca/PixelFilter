class_name ClientNode
extends Node

var udp := PacketPeerUDP.new()
var connected = false


func _ready():
	udp.connect_to_host("127.0.0.1", 80)

func _process(_delta):
	if !connected:
		# Try to contact server
		udp.put_packet((str(GlobalVar.width) + " .jpg").to_utf8_buffer())
	if udp.get_available_packet_count() > 0:
		#print("Connected: %s" % udp.get_packet())
		connected = true
		udp.put_packet((str(GlobalVar.width) + " .jpg").to_utf8_buffer())
		var peerpacket = udp.get_packet()
		create_texture_from_pool_byte_array(peerpacket)
		
		
# wait for input to request an image from server
func create_texture_from_pool_byte_array(byte_array):
	var im = Image.new()
	#print(byte_array.get_type())
	im.load_jpg_from_buffer(byte_array)   #<- Point of issue
	var im_tx = ImageTexture.create_from_image(im)
	
	$StreamSprite.texture = im_tx
	
# returning image data
