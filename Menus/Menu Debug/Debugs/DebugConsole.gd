extends Node

var console: Console
var buffer: Array[String] = []


func registrar_console(console_param: Console) -> void:
	console = console_param

	# envia tudo que foi logado antes
	for texto in buffer:
		console.add_text_console_sem_cor(texto)

	buffer.clear()


func add_text_console_sem_cor(texto: String) -> void:
	if console:
		console.add_text_console_sem_cor(texto)
	else:
		buffer.append(texto)


func add_text_console_com_cor(texto: String, cor: Color) -> void:
	if console:
		console.add_text_console_com_cor(texto, cor)
	else:
		buffer.append(texto)
