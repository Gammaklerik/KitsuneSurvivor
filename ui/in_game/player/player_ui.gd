extends Control

func _on_health_modified(value: float, max: float):
	$health_bar.value = value
	$health_bar.max_value = max
	$health_bar/hp_label.text = str(value) + "/" + str(max)

func _on_exp_changed(value: float, max: float):
	$exp_bar.value = value
	$exp_bar.max_value = max
	$exp_bar/exp_label.text = str(value) + "/" + str(max)

func _on_new_power(power: Node2D):
	var power_control_node : Control = Control.new()
	$power_ups_panel/margin/power_ups_container.add_child(power_control_node)
	power_control_node.add_child(power)
