extends Node2D


func play(organelle):
	$AnimatedSprite2D.play(organelle)
	
func get_frame(organelle):
	return $AnimatedSprite2D.sprite_frames.get_sprite_texture(organelle,0)
