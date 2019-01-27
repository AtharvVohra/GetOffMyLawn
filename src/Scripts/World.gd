extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var waveFinishedText = ["After my constant denial, they called to let me know that were coming to destroy everything I had left. The ambition of a skyscraper towering where my home stood drove them to come in hordes. They were coming to raze my precious memories, they were coming to raze my home. ", 
"I wasn’t going to hand it all over without a fight.", "I remember when Carlos and I first bought the house, just after we got married. The mornings we spent sipping tea on the porch, talking away as the sun rose are burnt into the walls that I defend.",
"The grass of the lawn has seen many seasons and a lot of birthday parties. We used to celebrate with a barbeque grill, some balloons, and a lot of heartfelt fun. Rosa and Angelo might have grown up, but there’ll always be a place in the lawn for their kids. I’ll make sure of it."
, "They thought I had nothing to lose. They know better now."]

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func updateText(wave):
	$WaveText.text = waveFinishedText[wave]
	$AnimationPlayer.play("New Wave")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "New Wave":
		$EnemySpawner.spawnWave()
		
func enemyDied():
	var enemyCount = get_tree().get_nodes_in_group("Enemy").size()
	print(enemyCount)
	if enemyCount == 0:
		var wave = $EnemySpawner.wave
		updateText(wave)
