extends Node
const PLAYER = preload("res://Player/Player.tscn")
var peer = ENetMultiplayerPeer.new()

func _on_buttony_button_forthe_hosty_thing_button_down() -> void:
	peer.create_server(2222)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(
		func(pid):
			print("peer "+str(pid)+" connected")
			_add_player(pid)
	)
	_add_player(multiplayer.get_unique_id())
func _on_buttony_button_forthe_client_button_down() -> void:
	peer.create_client("localhost",2222)
	multiplayer.multiplayer_peer = peer
func _add_player(pid):
	var player = PLAYER.instantiate()
	global.world.add_child(player)
