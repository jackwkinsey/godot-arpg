extends Node2D

var life_time = 0.25;
var decay = false;

onready var animated_sprite = $AnimatedSprite;

func _ready():
	animated_sprite.frame = 0;
	animated_sprite.play("FallApart");
	
func _process(delta):
	life_time -= delta;
	
	if (decay && life_time <= 0):
		queue_free();

func _on_AnimatedSprite_animation_finished():
	decay = true;
