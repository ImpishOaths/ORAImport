@tool
class_name ORAImport

extends EditorPlugin

var importPlugin = ORAImportPlugin.new()

func _enter_tree() -> void:
	add_import_plugin(importPlugin)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _exit_tree() -> void:
	remove_import_plugin(importPlugin)
