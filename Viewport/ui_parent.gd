extends CanvasLayer

signal sideBtnClicked
signal itemSlotClicked
func sideBoxClicked(_sender):
	sideBtnClicked.emit(_sender)
func clickItemSlot(_sender, _groups:Array):
	itemSlotClicked.emit(_sender,_groups)


func _on_skip_wave_bttn_button_down() -> void:
	global.waveSystem.start_wave()
