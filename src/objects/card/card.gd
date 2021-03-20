extends TextureButton

var type: String
var face: Texture
var back: Texture
var audio: AudioStream;

func init(new_type):
	type = new_type
	face = load("res://assets/textures/" + str(type) + ".png")
	back = load("res://assets/textures/card_back.png")
	audio = load("res://assets/audio/" + str(type) + ".ogg")
	if audio:
		$AudioStreamPlayer.set("stream", audio)
	set_normal_texture(back)

func flip():
	if get_normal_texture() == face:
		set_normal_texture(back)
	else:
		set_normal_texture(face)
		$AudioStreamPlayer.play()
		
