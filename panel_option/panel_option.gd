extends PanelContainer

signal config_changed()

var config_ori :Dictionary
var config :Dictionary
var editable_keys :Array
var filename :String

var lineedit_dict = {}

func init(fname:String, cfg:Dictionary, editkeys:Array, rt :Rect2, co1 :Color, co2 :Color)->void:
	filename = fname
	config_ori = cfg
	config = cfg
	editable_keys = editkeys

	size = rt.size
	position = rt.position
	theme.default_font_size = rt.size.y / 10

	# make label, lineedit
	for k in editable_keys:
		var lb = Label.new()
		lb.text = k
		$VBoxContainer/GridContainer.add_child(lb)
		var le = LineEdit.new()
		le.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		le.text = cfg[k]
		lineedit_dict[k]= le
		$VBoxContainer/GridContainer.add_child(le)

	config_to_control()

func config_to_control()->void:
	$VBoxContainer/ConfigLabel.text =Config.file_full_path(filename)
	$VBoxContainer/VersionLabel.text = config.version
	for k in editable_keys:
		lineedit_dict[k].text = config[k]

func reset_config()->void:
	config = config_ori
	Config.save_json(filename,config)
	config_to_control()

func _on_button_ok_pressed() -> void:
	hide()
	for k in editable_keys:
		config[k] = lineedit_dict[k].text
	Config.save_json(filename,config)

	config_changed.emit()

func _on_button_cancel_pressed() -> void:
	hide()

func _on_button_reset_pressed() -> void:
	reset_config()
