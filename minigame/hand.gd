extends Node2D
class_name Hand
'''
The avatar will pause its shaking after 0.1 second.
When motion_shake is detected, the 0.1-second timer to be reset,
and if shaking had been paused, it unpauses.
'''

var paused: bool
var drink_texture := 0.0

func unpause_shaking():
	paused = false
	%AnimationPlayer.play("shake")

func pause_shaking():
	paused = true
	%AnimationPlayer.stop(true)

func _ready():
	pause_shaking()

func _process(_delta: float) -> void:
	if Input.is_action_pressed("motion_shake"):
		drink_texture += 1 * _delta
		
		%Timer.start()  # reset timer
		if paused:
			unpause_shaking()

func _on_timer_timeout() -> void:
	pause_shaking()
