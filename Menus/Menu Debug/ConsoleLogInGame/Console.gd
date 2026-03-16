class_name Console
extends RichTextLabel

@onready var botao_limpar = $"../LimparButton"
@onready var botao_ir_para_final = $"../IrParaFinalButton"

func _ready() -> void:
	DebugConsole.registrar_console(self)
	
	scroll_active = true
	scroll_following = true
	
	botao_limpar.pressed.connect(limpar_console)
	botao_ir_para_final.pressed.connect(ir_para_final)
	botao_limpar.focus_mode = Control.FOCUS_NONE
	botao_ir_para_final.focus_mode = Control.FOCUS_NONE
	
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
