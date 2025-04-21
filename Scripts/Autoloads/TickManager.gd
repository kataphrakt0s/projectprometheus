extends Node

signal tick_advanced(tick_count)   # Emitted each tick
#signal tick_rate_changed(new_rate) # When ticks per second changes

var tick_count := 0

func _ready() -> void:
	# Connect to whatever node will emit the advance_tick signal
	# Example: EventBus.advance_tick.connect(_on_advance_tick)
	EventBus.advance_tick_requested.connect(_on_advance_tick)
	
func _on_advance_tick() -> void:
	tick_count += 1
	tick_advanced.emit(tick_count)
