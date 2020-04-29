extends KinematicBody2D

const ACCELERATION = 600;
const MAX_SPEED = 80;
const FRICTION = 600;

enum STATE{
	move,
	roll,
	attack
};

var state = STATE.move;
var velocity = Vector2.ZERO;
var input_vector = Vector2.ZERO;
var moving = false;
var start_direction = Vector2(0, 1);

var animation_tree : AnimationTree;
var state_machine_playback : AnimationNodeStateMachinePlayback;

func _ready():
	animation_tree = $AnimationTree;
	state_machine_playback = animation_tree.get("parameters/playback");
	animation_tree.active = true;
	animation_tree.set("parameters/Idle/blend_position", start_direction);
	animation_tree.set("parameters/Attack/blend_position", start_direction);

func _process(_delta):
	match state:
		STATE.move:
			move_state();
		STATE.roll:
			roll_state();
		STATE.attack:
			attack_state();

func _physics_process(delta):
	if moving:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta);
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta);
	
	velocity = move_and_slide(velocity);
	
func move_state():
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left");
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up");
	input_vector = input_vector.normalized();
	
	if input_vector != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", input_vector);
		animation_tree.set("parameters/Run/blend_position", input_vector);
		animation_tree.set("parameters/Attack/blend_position", input_vector);
		state_machine_playback.travel("Run");
		moving = true;
	else:
		moving = false;
		state_machine_playback.travel("Idle");
	
	if Input.is_action_just_pressed("attack"):
		moving = false;
		state_machine_playback.travel('Attack');
		state = STATE.attack;
	
	if Input.is_action_just_pressed("roll"):
		state = STATE.roll;
	
func attack_state():
	velocity = Vector2.ZERO;
	# It would be better if we had a way to know if the animation was done
	# playing, but we can't get access to the "finished" signal of the animation
	# when it is played inside an AnimationTree. Apparently there is an open
	# issue for this on GitHub: https://github.com/godotengine/godot/issues/28311
	if state_machine_playback.get_current_node() == "Idle":
		state = STATE.move;
	
func roll_state():
	print('ROLL');
	state = STATE.move;
