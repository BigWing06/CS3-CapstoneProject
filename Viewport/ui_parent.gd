extends CanvasLayer

signal sideBtnClicked
signal itemSlotClicked
func sideBoxClicked(_sender):
	sideBtnClicked.emit(_sender)
func clickItemSlot(_sender):
	itemSlotClicked.emit(_sender)
