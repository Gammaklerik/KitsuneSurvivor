extends Label

var wave_num : int :
	set(value):
		wave_num = value
		text = "Wave: " + str(wave_num)

func _ready():
	wave_num = 1

func _on_wave_cleared(waves_cleared: int):
	wave_num = 1 + waves_cleared
