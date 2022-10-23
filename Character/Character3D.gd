extends KinematicBody
class_name Character3D

export(float) var speed = 10
export(bool) var jump_enabled = true
export(float) var jump_speed = 10
export(float) var gravity = -10

var target_location = Vector3()
var has_target_location = false

func set_target_location(location : Vector3):
	target_location = location
	has_target_location = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(delta):
	# example of using navigation to automatically move the character
	if has_target_location:
		$NavigationAgent.set_target_location(target_location)

var velocity = Vector3()
var v_gravity = Vector3(0, gravity, 0)
func _physics_process(delta):
	
	velocity += v_gravity * delta
	
	var v_move = Vector3()
	v_move.x = 0
	v_move.z = 0
	if Input.is_action_pressed("up"):
		v_move += Vector3.FORWARD
	if Input.is_action_pressed("down"):
		v_move += Vector3.BACK
	if Input.is_action_pressed("left"):
		v_move += Vector3.LEFT
	if Input.is_action_pressed("right"):
		v_move += Vector3.RIGHT
		
	if jump_enabled and is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_speed
	
	
	# how to set the velocity of the character when navigating
	
	var delta_target = target_location - global_translation if has_target_location else Vector3()
	delta_target.y = 0
	has_target_location = not (delta_target as Vector3).is_equal_approx(Vector3())
	if has_target_location:
		var nav_direction = delta_target.normalized()
		var max_speed = delta_target.length() / delta
		v_move = nav_direction * min(speed, max_speed)
	else:
		v_move = v_move.normalized() * speed
		
	if v_move.x != 0 or v_move.z != 0:
		$CharacterRoot.look_at($CharacterRoot.global_translation + v_move, Vector3.UP)
		
	velocity.x = v_move.x
	velocity.z = v_move.z
	
	
	move_and_slide(velocity, Vector3.UP)
	if is_on_floor():
		velocity.y = 0
