extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var playerNode = get_tree().root.get_node("World/Player")
var movedir 
var playerPosition
var playerDistance
var velocity
var MOVE_SPEED = 300
var health = 40
	
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass


func _process(delta):
	playerPosition = playerNode.position
	 
	playerDistance = position.distance_to(playerPosition)
	# if distance < 20, attack
	if(playerDistance < 64):
		attack()
	else:
		move()
		
func attack():
	playerNode.health -= 20
	# play the animation and sound effect stuff
	
func move():
	# get the direction, move and slide
	velocity = (playerPosition - position).normalized() * MOVE_SPEED
    # rotation = velocity.angle()
	if (playerPosition - position).length() > 100:
    	move_and_slide(velocity)
		
func take_damage(damage):
	# if 3rd player hit, then down/stun, move back
	health -= damage
	if health <= 0:
		queue_free()
	if playerNode.specialAttack:
		# play animation for 1 sec
		health -= playerNode.playerSpecialDamage
		if $stuntimer.time_left != 0:
			$stuntimer.start()
			MOVE_SPEED = 300
		else:
			MOVE_SPEED = 0
	elif playerNode.heavyAttack:
		health -= playerNode.playerHeavyDamage
	else:
		health -= playerNode.playerLightDamage
		
