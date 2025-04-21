extends CanvasLayer

signal sideBtnClicked
signal itemSlotClicked
func sideBoxClicked(_sender):
	sideBtnClicked.emit(_sender)
func clickItemSlot(_sender, _groups:Array):
	itemSlotClicked.emit(_sender,_groups)
