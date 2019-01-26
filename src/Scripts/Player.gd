extends KinematicBody2D

export var NORMAL_SPEED = 500
var MOTION_SPEED = NORMAL_SPEED
var movedir = Vector2(0,0)
var CollisionNode
var playerPos
var mousePos
var trauma = 0
var haveBullet = true
var canShoot = true
var anim
var animNew
export var attacking = false
var health = 100.0

var lightAttack = false
var playerLightDamage = 10 
var heavyAttack = false
var playerHeavyDamage = 20
var specialAttack = false
var playerSpecialDamage = 30

var attackCounter = 0
var special = false

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	mousePos = get_global_mouse_position()
	#if playerControlEnabled:
	controls_loop(delta)
	movement_loop(delta)
	$CanvasLayer/Control/HealthBar.updateHealth(float(health)/100)
	if health > 0:
		health -= 0.5
	#updateCamera()

func updateCamera():
	var targetPosition = (mousePos*0.3+global_position*0.7)
	$Camera2D.global_position = (targetPosition*0.8+$Camera2D.global_position*0.2)
	var multiplier = randi()%2
	if multiplier == 0:
		multiplier = -1
	var offsetValue = (trauma*trauma) * 0.001 * multiplier
	$Camera2D.offset = Vector2(offsetValue, offsetValue)
	$Camera2D.rotation = trauma * 0.0001 * multiplier
	if trauma != 0:
		trauma -= 2.5
		if trauma < 0:
			trauma = 0


func controls_loop(delta):
	var LEFT	= Input.is_action_pressed("ui_left")
	var RIGHT	= Input.is_action_pressed("ui_right")
	var UP		= Input.is_action_pressed("ui_up")
	var DOWN	= Input.is_action_pressed("ui_down")
	var LIGHT_ATTACK = Input.is_action_just_pressed("ui_light_attack")
	var HEAVY_ATTACK = Input.is_action_just_pressed("ui_heavy_attack")
	
	

	if attacking:
		$HurtBox/CollisionShape2D.disabled = false
	else:
		$HurtBox/CollisionShape2D.disabled = true
		
	if LIGHT_ATTACK and !attacking:
		if(special):
			$AnimationPlayer.play("special_attack")
			special = false
			attackCounter = 0
		else:
			$AnimationPlayer.play("light_attack")
			attackCounter = attackCounter + 1
			if attackCounter == 3:
				special = true 
		
	if HEAVY_ATTACK and !attacking:
		if(special):
			$AnimationPlayer.play("special_attack")
			special = false
			attackCounter = 0
		else:
			$AnimationPlayer.play("heavy_attack")
			attackCounter += 1
			if attackCounter == 3:
				special = true
	
	
		
		
	if !attacking:
		movedir.x = -int(LEFT) + int(RIGHT)
		movedir.y = -int(UP) + int(DOWN)
	else:
		movedir = Vector2(0, 0)

	if movedir.x > 0:
		#anim = "PlayerWalkingRight"
		if $Sprite.flip_h == true:
			$Sprite.flip_h = false
			$HurtBox.position.x *= -1
	elif movedir.x < 0:
		#anim = "PlayerWalkingRight"
		if $Sprite.flip_h == false:
			$Sprite.flip_h = true
			$HurtBox.position.x *= -1

func movement_loop(delta):
	var motion = movedir.normalized() * MOTION_SPEED
	var collision = move_and_collide(motion*delta)
	if collision:
		move_and_slide(motion)
	if movedir == Vector2():
		anim = "Idle"
	if anim != animNew:
		animNew = anim
		#AnimNode.play(anim)
		