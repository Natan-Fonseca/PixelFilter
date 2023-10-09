extends Sprite2D

var pixelTam = material.get_shader_parameter("amount")
# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	if(Input.is_action_pressed("ui_up") and pixelTam <= 128):
		pixelTam += 1
		
	elif(Input.is_action_pressed("ui_down") and pixelTam > 0):
		pixelTam -= 1
	
	print(pixelTam)
	material.set_shader_parameter("amount", pixelTam)
