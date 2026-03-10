class_name PlaylistScript
extends Node

var musicas: Array[AudioStream] = []


func carregar_musicas():
	var dir = DirAccess.open("res://Cenas/CenaDebug/MusicasCenaDebug/")
	var arquivos: Array[String] = []

	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()

		while file_name != "":
			if not dir.current_is_dir():
				if (
					file_name.ends_with(".ogg")
					or file_name.ends_with(".mp3")
					or file_name.ends_with(".wav")
				):
					arquivos.append(file_name)

			file_name = dir.get_next()

		dir.list_dir_end()

	# ordenar pelos nomes
	arquivos.sort()

	# carregar na ordem
	for file_name in arquivos:
		var caminho = "res://Cenas/CenaDebug/MusicasCenaDebug/" + file_name
		var audio = load(caminho)
		musicas.append(audio)
