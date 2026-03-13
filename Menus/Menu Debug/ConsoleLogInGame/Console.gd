class_name Console
extends RichTextLabel

# Esse script trata de todas as funcoes pro log
# Funcoes como adicionar um texto
# limpar o log
# Adicionar um texto com cor
# Como ele vai ser so um script usado em algo, nao vai ser criado no mundo
# Creio que nao precisamos botar class_name nele
# Me corrigam se eu estiver errado

func _ready() -> void:
	DebugConsole.registrar_console(self)
	
	scroll_active = true
	scroll_following = true
	
	
func add_text_console_sem_cor(texto: String) -> void:
	append_text("[color=#ffffff]%s[/color]\n" % [texto])
	
func add_text_console_com_cor(texto: String, cor: Color) -> void:
	var cor_hex = cor.to_html() 
	print(cor_hex)
	append_text("[color=#%s]%s[/color]\n" % [cor_hex, texto])
	
func ir_para_final() -> void:
	scroll_to_line(get_line_count() - 1)

func limpar_console() -> void:
	clear()
