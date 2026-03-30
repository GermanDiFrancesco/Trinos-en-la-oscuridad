extends Control

func play(name):
	$AnimationPlayer.play(name)
	await $AnimationPlayer.animation_finished
	if name =="intro_flautista": Global.saveData.cinematic_wached.intro =true
	Global.save_data()
