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
export var maxHealth = 60.0
var health = maxHealth
export var damage = 10
var anim
var animNew

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass


func _process(delta):
	playerPosition = playerNode.position
	 
	playerDistance = position.distance_to(playerPosition)
	# if distance < 20, attack
	if(playerDistance < 80):
		attack()
		anim = "Attack"
	else:
		move()
		anim = "Walking"
		
	#if movedir == Vector2() and !attacking:
	#	anim = "idle"
	if anim != animNew:
		animNew = anim
		$AnimationPlayer.play(anim)
	
	
		
func attack():
	pass#playerNode.takeDamage(damage)
	# play the animation and sound effect stuff
	
func move():
	# get the direction, move and slide
	velocity = (playerPosition - position).normalized() * MOVE_SPEED
    # rotation = velocity.angle()
	if (playerPosition - position).length() > 80:
    	move_and_slide(velocity)
		
func take_damage(damage, damageType):
	# if 3rd player hit, then down/stun, move back
	health -= damage
	$HealthBar.value = (float(health)/float(maxHealth))*100
	#Light=0, Heavy=1, Special == 2
	if damageType == 2:
		# play animation for 1 sec
		$HealthBar.value -= 20
		if $stuntimer.time_left != 0:
			$stuntimer.start()
			MOVE_SPEED = 300
		else:
			MOVE_SPEED = 0
		
	if health <= 0:
		queue_free()
		
