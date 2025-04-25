extends Control

@onready var progress_bar: ProgressBar = $ProgressBar

func update_progress(progress: float) -> void:
	progress_bar.value = progress * 100
