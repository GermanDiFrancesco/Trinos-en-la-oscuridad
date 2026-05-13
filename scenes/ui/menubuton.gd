extends TextureButton

func _on_focus_entered() -> void:
	$Label.label_settings.font_color = Color(1,1,1)
	$Label.label_settings.font_size = 26

func _on_focus_exited() -> void:
	$Label.label_settings.font_color = Color(0,0,0)
	$Label.label_settings.font_size = 22
