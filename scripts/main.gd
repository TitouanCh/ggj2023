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
var bodies = []

var decibelTree = 0
var decibelTreeTemp = 0

var decibelBattle = 0
var decibelBattleTemp = 0

var audios = []

func _ready():
#	intro = introScene.instance()
#	add_child(intro)
	startGeneration(generation)
	for i in range(10):
		var a = AudioStreamPlayer.new()
		self.add_child(a)
		audios.append(a)
#	choosePerk()
	

func startMusic():
	$music.play()

func _process(delta):
	# - AUDIO
	AudioServer.set_bus_volume_db(2, decibelBattleTemp)
	decibelBattleTemp = lerp(decibelBattleTemp, decibelBattle, delta * 10)
	
	AudioServer.set_bus_volume_db(1, decibelTreeTemp)
	decibelTreeTemp = lerp(decibelTreeTemp, decibelTree, delta * 10)
	
	if tree:
		player.position = player.position.linear_interpolate(Vector2.ZERO, delta * 5)
	
	$shader.position = player.position - Vector2(500, 500)

func startGeneration(generation):
	for body in bodies:
		body.destroy()
	bodies = []
	enemies = []
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
	player.position = Vector2.ZERO
	if Global.active_upgrades.has("Less health") :
		player.healthMax = player.healthMax + 80
	if Global.active_upgrades.has("Less attack") :
		player.attack = player.attack - 50
	if Global.active_upgrades.has("Slower movement") :
		player.accel = Vector2(400,400)
	if Global.active_upgrades.has("Drunk") :
		bourre_function()
	
func bourre_function():
	yield(get_tree().create_timer(2.0), "timeout")
	player.accel = Vector2(random.randi_range(200,1200),random.randi_range(200,1200))
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
		a.position = Vector2(randf() * roomSize.x, randf() * roomSize.y) - roomSize/2
	
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

func playSound(sound, rand = true):
	for a in audios:
		if !a.is_playing():
			if rand: a.pitch_scale = randf()/10 + 0.9
			var l = load("res://sounds/" + sound)
			if l:
				a.stream = l
				a.play()
			break

func playerDied():
	for enemy in enemies:
		if is_instance_valid(enemy):
			enemy.queue_free()

func restart():
	Global.active_upgrades = []
	get_tree().change_scene("res://scenes/flask.tscn")
