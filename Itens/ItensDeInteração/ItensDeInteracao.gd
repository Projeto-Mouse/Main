class_name ItensDeInteracao
extends Item

# Definimos um sinal que envia o próprio item como informação
signal pedido_de_interacao(item_que_foi_tocado)

# Esta função roda sempre que uma tecla é pressionada
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Interagir") and jogador_na_area:
		interagir()

func interagir() -> void:
	print("Tentativa de interagir com: ", nome)
	
	# Emite o sinal enviando 'self' (este script/nó) como parâmetro
	pedido_de_interacao.emit(self)
	
