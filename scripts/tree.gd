extends Node2D
var noeudScene = load("res://scenes/noeud.tscn")
var treeImage1
var boucletree = 0
var name1erchoix = "on verra "
var name21erchoix = "on verra "
var name22erchoix = "on verra "

var incrementY = 75

var choix = {
	"test1":
		{
			"test4":{},
			"test5":{}
		}, 
	"test2": {
			"test6":{},
			"test7":{}
	},
	"test3":{
			"test8":{},
			"test9":{}
	}
	}

func _ready():
	
	boucletree+=1
	
#	var a = noeudScene.instance()
#	if (boucletree == 1):
#		print(name1erchoix)
#	var b = self.add_child(a)
#	if (boucletree ==2):
#		print(name1erchoix)
#		Input.is_action_pressed("click"):

	
#	var b = self.add_child(a)
	createTree(choix)

func createTree(data, parent = self, modx = 0200):
	for i in range(len(data.keys())):
		createNoeud(data.keys()[i], data[data.keys()[i]], parent, modx, i, len(data.keys()))

func createNoeud(n, choix, parent, modx, childnumber, nchild):
	var a = noeudScene.instance()
	parent.add_child(a)
	a.name = n
	print(n)
	print(parent.position + calculx(nchild, modx/2, childnumber))
	a.position = calculx(nchild, modx/2, childnumber)
	createTree(choix, a, modx/2)
	
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
	print(nchild)
	print(childnumber)
	
