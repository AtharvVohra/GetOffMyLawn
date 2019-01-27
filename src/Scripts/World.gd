extends Node2D

# class member variables go here, for example:
var enemyCount = 1
var waveFinishedText = ["After my constant refusal, they called to let me know that were coming to destroy everything I had left. They want to build a skyscraper towering where my home stands. They were coming to trample my precious memories... They were coming to raze my home. ", 
"I wasn't going to hand it over without a fight.", "I remember when Carlos and I bought the house, just after we got married.","The mornings we spent sipping tea on the porch, talking away as the sun rose, are burnt into the walls that I defend.",
"The grass of the lawn has seen many seasons and a lot of birthday parties. We used to celebrate with a barbeque grill, some balloons, and heartfelt fun.","Rosa and Angelo might have grown up, but there'll always be a place in the lawn for their kids. I'll make sure of it."
, "They thought I had nothing to lose. They know better now.",
]
var victoryText = "The construction workers stood no chance."

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
	enemyCount -= 1
	if enemyCount == 0:
		var wave = $EnemySpawner.wave
		if wave <= 7:
			updateText(wave-1)
		else:
			victory()

func victory():
	$WaveText.text = victoryText
	$AnimationPlayer.play("New Wave")
	$AnimationPlayer.play("Victory Sequence")