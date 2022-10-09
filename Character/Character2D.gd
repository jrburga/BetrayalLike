tool
extends KinematicBody2D
class_name Character2D

export(float) var speed = 10
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
var velocity : Vector2
func _process(delta):
	if Engine.editor_hint:
		return
		
	velocity = Vector2.ZERO
	if Input.is_action_pressed("up"):
		velocity += Vector2.UP
	if Input.is_action_pressed("down"):
		velocity += Vector2.DOWN
	if Input.is_action_pressed("left"):
		velocity += Vector2.LEFT
		$Sprite.flip_h = true
	if Input.is_action_pressed("right"):
		velocity += Vector2.RIGHT
		$Sprite.flip_h = false
	
	velocity = velocity.normalized() * speed
	move_and_slide(velocity)

