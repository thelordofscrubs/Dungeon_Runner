extends Control

func _init():
	var array = []
	for x in range(10):
		array.append(x)
	print(str(array))
	array.erase(3)
	print(str(array)+" : "+str(array.size()))