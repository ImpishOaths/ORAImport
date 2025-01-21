@tool
class_name ORAImportPlugin

extends EditorImportPlugin

func _get_importer_name() -> String:
	return "ImpishOaths.ORAImport"
func _get_visible_name() -> String:
	return "ORA Import"
func _get_recognized_extensions() -> PackedStringArray:
	return ["ora"]
func _get_save_extension() -> String:
	return "tres"
func _get_resource_type() -> String:
	return "Texture2DArray"
func _get_priority() -> float:
	return 1
func _get_import_options(path: String, preset_index: int) -> Array[Dictionary]:
	return []
func _get_preset_count() -> int:
	return 0
func _import(source_file: String, save_path: String, options: Dictionary, platform_variants: Array[String], gen_files: Array[String]) -> Error:
	var filePath = ProjectSettings.globalize_path(source_file)
	var zip: ZIPReader
	zip.open(filePath)
	var rawImages: Array[Image]
	var layerNames: Array[String]
	var offsets: Dictionary
	var width = 0;
	var height = 0;
	for entry in zip.get_files():
		if entry == "stack.xml":
			var xml: XMLParser
			var bArray = zip.read_file(entry)
			xml.open_buffer(bArray)
			xml.read() #<?xml
			xml.read() #<image
			width = int(xml.get_attribute_value(0))
			height = int(xml.get_attribute_value(1))
			xml.read() #<stack
			while xml.get_node_type() != XMLParser.NODE_ELEMENT_END:
				var name = xml.get_attribute_value(2)
				var x = int(xml.get_attribute_value(4))
				var y = int(xml.get_attribute_value(5))
				offsets[Vector2i(x,y)] = name
		if entry.begins_with("data/"):
			var bArray = zip.read_file(entry)
			var image: Image
			image.load_png_from_buffer(bArray)
			rawImages.push_back(image)
			layerNames.push_back(entry)
	zip.close()
	
	if width == 0 || height == 0:
		return FAILED
	var finalImages: Array[Image]
	for i in range(len(rawImages)):
		var newImage = Image.create_empty(width, height, false, Image.FORMAT_RGBA8)
		var image = rawImages[i]
		newImage.blit_rect(image, Rect2i(0, 0, image.get_width(), image.get_height()), offsets[layerNames[i]])
		finalImages.push_back(newImage)
	var texture: Texture2DArray
	texture.create_from_images(finalImages)
	return ResourceSaver.save(texture, save_path + "." + _get_save_extension())
	
	
	
	
	
	
	
	
	
