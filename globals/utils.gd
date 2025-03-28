extends Node

func randWeightedFromDict(_dict: Dictionary): # Takes in a dictionary (formatted "key": weight) and returns a random key using the weighting provided
	var _weightedList = []
	for key in _dict.keys():
		for i in range(int(_dict[key])):
			_weightedList.append(key)
	return _weightedList.pick_random()
	
