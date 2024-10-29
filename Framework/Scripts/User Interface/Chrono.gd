# @description: A simple chronometer that displays elapsed time in minutes and seconds.
# @author: Daniel Guerra Gallardo. (@DakkuaDev)
# @date: 10/2024

extends Label 

# Exposed variables
@export var start_at_beginning: bool = true # Indicates whether the chronometer should start running immediately.

# Internal variables
var on_chrono: bool = false  # Indicates if the chronometer is currently running.
var elapsed_time: float = 0.0  # Holds the total elapsed time in seconds.

# Initializes the label and starts the chronometer if needed.
func _ready():
	# @description: Set the label text to "00:00" and start the chronometer if 'start_at_beginning' is true.
	text = "00:00"
	
	# Start the chronometer if 'start_at_beginning' is true
	if(start_at_beginning):
		on_chrono = true
	
	pass

# Processes frame updates to manage the chronometer.
func _process(delta: float):
	# @description: If the chronometer is running, update the elapsed time and display.
	if(on_chrono):
		elapsed_time += delta  # Increment elapsed time by delta time.
		text = format_time(elapsed_time)  # Update the label with formatted time.
	
	pass

# Formats the elapsed time into a string.
func format_time(time: float) -> String:
	# @param time: The elapsed time in seconds as a float.
	# @return: A formatted string representing minutes and seconds in "MM:SS" format.
	
	var minutes = int(int(time / 60) % 60)  # Calculate minutes.
	var seconds = int(int(time) % 60)  # Calculate seconds.
	return ("%02d" % minutes) + (":%02d" % seconds)  # Return formatted time string.

	pass

# Resets the chronometer to its initial state.
func reset_chrono() -> void:
	# @description: Reset the label text and elapsed time to starting conditions.
	text = "00:00"  # Reset display to "00:00".
	elapsed_time = 0.0  # Reset elapsed time to zero.
	
	pass
