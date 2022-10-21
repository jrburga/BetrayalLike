extends KinematicBody
class_name Character3D

export(NodePath) var target_position_3d = null
export(float) var speed = 10
export(bool) var jump_enabled = true
export(float) var jump_speed = 10
export(float) var gravity = -10

# Called when the node enters the scene tree for the first time.
func _ready():
	if target_position_3d != null:
		var target_position = get_node(target_position_3d) as Position3D
		var location = target_position.global_translation
		$NavigationAgent.set_target_location(location)
		print($NavigationAgent.get_final_location())


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(delta):
	# example of using navigation to automatically move the character
	if target_position_3d != null:
		var target_position = get_node(target_position_3d) as Position3D
		var location = target_position.global_translation
		$NavigationAgent.set_target_location(location)

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
	# var nav_direction = ($NavigationAgent.get_next_location() - global_translation).normalized()
	# v_move = nav_direction * speed
	
	v_move = v_move.normalized() * speed
	velocity.x = v_move.x
	velocity.z = v_move.z
	
	move_and_slide(velocity, Vector3.UP)
	if is_on_floor():
		velocity.y = 0
