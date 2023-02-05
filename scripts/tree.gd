extends Node2D

var noeudScene = load("res://scenes/noeud.tscn")
var treeImage1
var player = null
var boucletree = 0
var name1erchoix = "on verra "
var name21erchoix = "on verra "
var name22erchoix = "on verra "

var choosen = true

var Yoffset = 0

var baseModX = 100
var incrementY = 30

var choix = {
	"Enemy Swat":
		{
			"-Pv": {
				"test8": {},
				"test9": {}
			},
			"-Atk":{}
		}, 
	"+3 Enemies": {
			"+3 Enemies ":{
				"Bourré": {},
				"Inversion":{}
			},
			"- Mvt":{}
	}
	}

func _ready():
	
	boucletree+=1
	createTree(choix)

func startMusic():
	$music.play()

func _process(delta):
	if player: self.position = self.position.linear_interpolate(player.position - Vector2(0, Yoffset), delta * 40)
	update()
	
	$test.global_position = get_global_mouse_position()/2 + Vector2(-130, -75) + player.position/2

func get_player_position():
	return player.position

func createTree(data, parent = self, modx = baseModX):
	for i in range(len(data.keys())):
		createNoeud(data.keys()[i], data[data.keys()[i]], parent, modx, i, len(data.keys()))

func createNoeud(n, choix, parent, modx, childnumber, nchild):
	var a = noeudScene.instance()
	parent.add_child(a)
	a.name = n
	a.connect("send_desc", parent, "show_desc")
	a.connect("unlock_ability", parent, "ability_is_unlocked")
	if Global.active_upgrades.has(n):
		a.choosen = true
		a.unlocked = true
#	print(n)
#	print(parent.position + calculx(nchild, modx/2, childnumber))
	a.position = calculx(nchild, modx/2, childnumber)
	createTree(choix, a, modx/2)
	
	if a.position.y > Yoffset:
		Yoffset = a.global_position.y/2
	
func calculx(nchild, modx, childnumber):
	if nchild == 1:
		return Vector2(0, incrementY)
	if nchild == 2:
		if childnumber == 0:
			return Vector2(-modx, incrementY)
		if childnumber == 1:
			return Vector2(modx, incrementY)
	if nchild == 3:
		if childnumber == 0:
			return Vector2(-modx/.5, incrementY)
		if childnumber == 1:
			return Vector2(0, incrementY)
		if childnumber == 2:
			return Vector2(modx/.5, incrementY)
#	print(nchild)
#	print(childnumber)
	
func _draw():
	for child in get_children():
		if child is Node2D:
			if choosen:
				draw_line(Vector2.ZERO, child.position, Color(255, 255, 0),2)
			else:
				draw_line(Vector2.ZERO, child.position, Color(255, 255, 255),2)

func show_desc(id):
	if $skillDesc.bbcode_text != get_desc(id):
		$skillDesc.bbcode_text = get_desc(id)

func get_desc(id):
	var desc = "[wave amp=20 freq=2][b]" + id + "[/b]" + "\n"
	if Global.upgrades_desc.keys().has(id):
		desc += Global.upgrades_desc[id]
	return desc

func ability_is_unlocked():
	if get_parent(): get_parent().startGeneration(get_parent().generation)
	queue_free()

func playSound(n):
	get_parent().playSound(n)
