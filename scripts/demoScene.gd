extends Node2D

var enemyScene = preload("res://scenes/enemy.tscn")

var player
var minDistanceToPlayer = 200
var roomSize = Vector2(400, 400)
var bodies = []

func _ready():
	player = $player

func _process(delta):
	if Input.is_action_just_pressed("debug1"):
		spawnEnemy()

func spawnEnemy(type = "melee", i = 0):
	var a = enemyScene.instance()
	self.add_child(a)

	a.player = player
	a.position = player.position
	a.setType(type, i)
	 
	while a.position.distance_to(player.position) < minDistanceToPlayer:
		a.position = Vector2(randf() * roomSize.x, randf() * roomSize.y) - roomSize/2
	
	print("-- Spawned enemy at : " + str(a.position))

func playSound(test):
	pass
