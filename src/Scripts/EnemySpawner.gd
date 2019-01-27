extends Node2D

var centerpos
var size = Vector2(0,0)
var positionInArea = Vector2(0,0)
export (PackedScene) var enemy
var x = 0
var wave = 1
var waves = [1, 2, 2, 3, 5]
var world

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	centerpos = $CollisionShape2D.position# + position
	size.x = $CollisionShape2D.shape.extents.x * scale.x
	size.y = $CollisionShape2D.shape.extents.y * scale.y
	world = get_tree().root.get_node("World")


func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	pass

func spawn():
	positionInArea.x = (randf() * size.x) - (size.x/2) + centerpos.x + position.x
	positionInArea.y = (randf() * size.y) - (size.y/2) + centerpos.y + position.y
	var spawn = enemy.instance()
	spawn.position = positionInArea
	world.add_child(spawn)
	
func spawnWave():
	if wave < len(waves):
		for i in range(waves[wave]):
			spawn()
			world.enemyCount += 1
		wave += 1