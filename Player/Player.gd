extends KinematicBody2D

const ACCELERATION = 500;
const MAX_SPEED = 80;
const FRICTION = 500;

var velocity = Vector2.ZERO;

onready var animation_player = $AnimationPlayer;

func _physics_process(delta):
	var input_vector = Vector2.ZERO;
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left");
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up");
	input_vector = input_vector.normalized();
	
	if input_vector != Vector2.ZERO:
		if input_vector.x > 0:
			animation_player.play("RunRight");
		else:
			animation_player.play("RunLeft");
		
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta);
	else:
		animation_player.play("IdleRight");
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta);
		
	velocity = move_and_slide(velocity);
