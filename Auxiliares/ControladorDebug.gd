extends Node


var dev_mode: bool = false

func ativar():
	dev_mode = true
	print("MODO DESENVOLVEDOR ATIVADO!")

func desativar():
	dev_mode = false
	print("MODO DESENVOLVEDOR DESATIVADO!")

func alternar():
	dev_mode = !dev_mode
	print("DEV MODE:", dev_mode)

func is_dev()  -> bool:
	return dev_mode
