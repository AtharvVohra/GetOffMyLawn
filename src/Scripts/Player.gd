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

export var lightAttack = false
export var playerLightDamage = 10 
export var heavyAttack = false
export var playerHeavyDamage = 20
export var specialAttack = false
export var playerSpecialDamage = 30

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
		

func _on_HurtBox_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(500)

func takeDamage(damage):
	health -= 1
	if health <= 0:
		$CollisionShape2D.disabled = true
		hide()
