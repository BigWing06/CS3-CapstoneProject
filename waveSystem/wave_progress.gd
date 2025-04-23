extends VBoxContainer


func updateValue(_waveTitle,_waveDuration): # Updates the bar with the new data and plays the animation
	$WaveProgress.value = 100
	$WaveNumber.text = str(_waveTitle)
	$AnimationPlayer.speed_scale = 1.0 / float(_waveDuration-0.5) # This is how fast to play the animation. Have to subtract 0.5 seconds so that it ends before the next wave starts and is able to register incoming data
	$AnimationPlayer.play("Countdown")
