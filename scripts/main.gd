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
	
	choosePerk()

func startGeneration(generation):
	print("Start Generation " + str(generation))
	spawnPlayer()
	for i in range(numberOfEnemies):
		spawnEnemy()
	print("-> " + str(actualNumberOfEnemies) + " Enemies")

func spawnPlayer():
	var a = playerScene.instance()
	self.add_child(a)
	player = a
	player.position = roomSize/2

func spawnEnemy():
	var a = enemyScene.instance()
	self.add_child(a)
	enemies.append(a)
	actualNumberOfEnemies += 1
	a.position = player.position
	
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