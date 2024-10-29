extends Label

@export var start_at_beginning: bool = true

var on_chrono: bool = false
var elapsed_time: float = 0.0

func _ready():
	text = "00:00"
	if(start_at_beginning):
		on_chrono = true
		
	pass

func _process(delta: float):
	if(on_chrono):
		elapsed_time += delta
		text = format_time(elapsed_time)
		
	pass
	
func format_time(time: float) -> String:
	var minutes = int(int(time / 60) % 60)
	var seconds = int(int(time) % 60)
	return ("%02d" % minutes) + (":%02d" % seconds)
	
	pass
	
func reset_chrono() -> void:
	text = "00:00"
	elapsed_time = 0.0
	
	pass

