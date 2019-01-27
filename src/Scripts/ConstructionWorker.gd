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
export var attacking = false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass


func _process(delta):
	playerPosition = playerNode.position
	 
	playerDistance = position.distance_to(playerPosition)
	# if distance < 20, attack
	if attacking:
		$HurtBox/CollisionShape2D.disabled = false
	else:
		$HurtBox/CollisionShape2D.disabled = true
		
	if(playerDistance < 60):
		attack()
		anim = "Attack"
	else:
		move()
		anim = "Walking"
		
	#if movedir == Vector2() and !attacking:
	#	anim = "idle"
	if anim != animNew:
		animNew = anim
		$Whoosh2.play()
		$AnimationPlayer.play(anim)
	
	
		
func attack():

	pass#playerNode.takeDamage(damage)
	# play the animation and sound effect stuff
	
func move():
	# get the direction, move and slide
	velocity = (playerPosition - position).normalized() * MOVE_SPEED
    # rotation = velocity.angle()
	if (playerPosition - position).length() > 60:
    	move_and_slide(velocity)
	if velocity.x > 0:
		if $Sprite.flip_h == true:
			$Sprite.flip_h = false
			$HurtBox.position.x *= -1
	elif velocity.x < 0:
		if $Sprite.flip_h == false:
			$Sprite.flip_h = true
			$HurtBox.position.x *= -1
		
func take_damage(damage, damageType):
	# if 3rd player hit, then down/stun, move back
	health -= damage
	$HealthBar.value = (float(health)/float(maxHealth))*100
	#Light=0, Heavy=1, Special == 2
	if damageType == 0: #Light attack
		move_and_slide(Vector2(velocity.x * -10,0))
	if damageType == 3:
		# play animation for 1 sec
		if $stuntimer.time_left != 0:
			$stuntimer.start()
			MOVE_SPEED = 300
		else:
			MOVE_SPEED = 0
		
	if health <= 0:
		$DeathSound.play()
		queue_free()


func _on_HurtBox_body_entered(body):
	if body.is_in_group("Player"):
		playerNode.take_damage(damage)
