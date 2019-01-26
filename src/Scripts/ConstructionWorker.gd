extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var playerNode = get_node("Player")
var MOVE_SPEED = 300

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	playerPosition = get_node("Player").position
	 
	playerDistance = position.distance_to(playerPosition)
	# if distance < 20, attack
	if(playerDistance < 5):
		attack()
	else:
		move()
		
func attack():
	playerNode.health -= 20
	
	
func move():
	var motion = movedir.normalized() * MOTION_SPEED
	var collision = move_and_collide(motion*delta)
	if collision:
		move_and_slide(motion)
	if movedir == Vector2():
		anim = "Idle"
	if anim != animNew:
		animNew = anim
		#AnimNode.play(anim)
	
	
