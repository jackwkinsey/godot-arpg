extends KinematicBody2D

const ACCELERATION = 600;
const MAX_SPEED = 80;
const FRICTION = 600;

var velocity = Vector2.ZERO;
var start_direction = Vector2(0, 1);

onready var animation_tree = $AnimationTree;
onready var animation_state = animation_tree.get("parameters/playback");

func _ready():
	animation_tree.set("parameters/Idle/blend_position", start_direction);

func _physics_process(delta):
	var input_vector = Vector2.ZERO;
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left");
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up");
	input_vector = input_vector.normalized();
	
	if input_vector != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", input_vector);
		animation_tree.set("parameters/Run/blend_position", input_vector);
		animation_state.travel("Run");
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta);
	else:
		animation_state.travel("Idle");
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta);
		
	velocity = move_and_slide(velocity);
