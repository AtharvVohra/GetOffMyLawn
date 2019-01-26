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

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	mousePos = get_global_mouse_position()
	#if playerControlEnabled:
	controls_loop(delta)
	movement_loop(delta)
	updateCamera()

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
	var SHOOT	= Input.is_action_just_pressed("ui_shoot")
	var RESTART	= Input.is_action_pressed("ui_restart")
	var PAUSE = Input.is_action_pressed("ui_cancel")

	if RESTART:
		get_tree().reload_current_scene()
	movedir.x = -int(LEFT) + int(RIGHT)
	movedir.y = -int(UP) + int(DOWN)
	

	if movedir.x > 0:
		#anim = "PlayerWalkingRight"
		$Sprite.flip_h = false
	elif movedir.x < 0:
		#anim = "PlayerWalkingRight"
		$Sprite.flip_h = true
	

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
		