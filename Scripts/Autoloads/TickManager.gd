extends Node

signal tick_advanced(tick_count)   # Emitted each tick
#signal tick_rate_changed(new_rate) # When ticks per second changes

var tick_count := 0
var tick_rate := 60                # Ticks per second
var accumulated_time := 0.0
var tick_length: float:
	get: return 1.0 / tick_rate

func _process(delta: float) -> void:
	accumulated_time += delta
	while accumulated_time >= tick_length:
		accumulated_time -= tick_length
		tick_count += 1
		tick_advanced.emit(tick_count)
