extends Node2D


var generation = 0

var enemyScene = preload("res://scenes/enemy.tscn")
var playerScene = preload("res://scenes/player.tscn")

var treeScene = preload("res://scenes/tree.tscn")

var roomSize = Vector2(400, 400)
var minDistanceToPlayer = 100

var player = null
var tree = null

var numberOfEnemies = 3
var actualNumberOfEnemies = 0
var enemies = []

func _ready():
	startGeneration(generation)
	
#	choosePerk()

func startGeneration(generation):
	if player: player.queue_free()
	print("Start Generation " + str(generation))
	spawnPlayer()
	numberOfEnemies = 3 + int(Global.active_upgrades.has("+3 Enemies")) * 3
	for i in range(numberOfEnemies):
		if Global.active_upgrades.has("Enemy Swat") and i < 3:
			spawnEnemy("swat")
		if Global.active_upgrades.has("+3 Enemies ") and i < 6:
			#numberOfEnemies = numberOfEnemies + 9
			spawnEnemy()
			spawnEnemy()
		else:
			spawnEnemy()
	print("-> " + str(actualNumberOfEnemies) + " Enemies")
	generation += 1
	

func spawnPlayer():
	var a = playerScene.instance()
	self.add_child(a)
	player = a
	player.position = roomSize/2
	if Global.active_upgrades.has("-Pv") :
		player.healthMax = player.healthMax+80
	if Global.active_upgrades.has("-Atk") :
		player.attack = player.attack-50
	if Global.active_upgrades.has("- Mvt") :
		player.accel = Vector2(400,400)

func spawnEnemy(type = "melee"):
	var a = enemyScene.instance()
	self.add_child(a)
	enemies.append(a)
	a.player = player
	actualNumberOfEnemies += 1
	a.position = player.position
	a.setType(type)
	 
	
	while a.position.distance_to(player.position) < minDistanceToPlayer:
		a.position = Vector2(randf() * roomSize.x, randf() * roomSize.y)
	
	print("-- Spawned enemy at : " + str(a.position))

func reduceEnemyCount():
	actualNumberOfEnemies -= 1
	print("> " + str(actualNumberOfEnemies) + " Enemies left")
	if actualNumberOfEnemies <= 0:
		choosePerk()

func choosePerk():
	tree = treeScene.instance()
	player.visible = false
	self.add_child(tree)
	tree.player = player

