extends Node

@export_node_path("State") var base_state: NodePath

var states: Dictionary = {}
var current_state: Node = null

func _ready():
	await owner.ready
	for child: State in get_children():
		if not child is State:
			print("%s is not a state node" % child.name)
			continue
			
		var signals_dict = {}
		
		for signal_name in ["state_enter", "state_exit", "state_update", "state_physics_update"]:
			if child.get_signal_connection_list(signal_name):
				signals_dict[signal_name] = true
			else:
				signals_dict[signal_name] = false
		
		states[child.name] = signals_dict
		
	change_state(get_node(base_state).name)

func change_state(new_state: String):
	if not new_state in states.keys():
		print("%s is not a valid state" % new_state)
		return
	
	if current_state:
		state_on_exit()
	current_state = get_node(new_state)
	state_on_enter()
	
	Global.debug_values.add_debug_value("State", new_state)
	
	#print("changed to %s" % [new_state])

func state_on_enter():
	if states[current_state.name]["state_enter"]:
		current_state.emit_signal("state_enter")

func state_on_exit():
	if states[current_state.name]["state_exit"]:
		current_state.emit_signal("state_exit")

func state_process(delta):
	if states[current_state.name]["state_update"]:
		current_state.emit_signal("state_update", delta)

func state_physics_process(delta):
	if states[current_state.name]["state_physics_update"]:
		current_state.emit_signal("state_physics_update", delta)
