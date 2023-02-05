extends Node2D


var generation = 0

var introScene = preload("res://scenes/introduction.tscn")

var enemyScene = preload("res://scenes/enemy.tscn")
var playerScene = preload("res://scenes/player.tscn")

var treeScene = preload("res://scenes/tree.tscn")

var roomSize = Vector2(400, 400)
var minDistanceToPlayer = 100
var random = RandomNumberGenerator.new()

var player = null
var tree = null
var intro = null

var numberOfEnemies = 3
var actualNumberOfEnemies = 0
var enemies = []

var decibelTree = 0
var decibelTreeTemp = 0

var decibelBattle = 0
var decibelBattleTemp = 0



func _ready():
	intro = introScene.instance()
	add_child(intro)
	
#	startGeneration(generation)
	
#	choosePerk()

func startMusic():
	$music.play()

func _process(delta):
	# - AUDIO
	AudioServer.set_bus_volume_db(2, decibelBattleTemp)
	decibelBattleTemp = lerp(decibelBattleTemp, decibelBattle, delta * 10)
	
	AudioServer.set_bus_volume_db(1, decibelTreeTemp)
	decibelTreeTemp = lerp(decibelTreeTemp, decibelTree, delta * 10)

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
	decibelBattle = 0
	

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
	if Global.active_upgrades.has("Bourré") :
		bourre_function()
	
func bourre_function():
	print("start")
	yield(get_tree().create_timer(2.0), "timeout")
	player.accel = Vector2(random.randi_range(200,1200),random.randi_range(200,1200))
	print("end")
	return bourre_function()

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
	decibelBattle = -69
