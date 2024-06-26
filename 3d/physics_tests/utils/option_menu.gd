class_name OptionMenu
extends MenuButton


signal option_selected(item_path)
signal option_changed(item_path, checked)


func add_menu_item(item_path, checkbox = false, checked = false):
	var path_elements = item_path.split("/", false)
	var path_element_count = path_elements.size()
	assert(path_element_count > 0)

	var path = ""
	var popup = get_popup()
	for element_index in range(path_element_count - 1):
		var popup_label = path_elements[element_index]
		path += popup_label + "/"
		popup = _add_popup(popup, path, popup_label)

	var label = path_elements[path_element_count - 1]
	if checkbox:
		popup.add_check_item(label)
		popup.set_item_checked(popup.get_item_count() - 1, checked)
	else:
		popup.add_item(label)


func _add_item(parent_popup, label):
	parent_popup.add_item(label)


func _add_popup(parent_popup, path, label):
	if parent_popup.has_node(label):
		var popup_node = parent_popup.get_node(label)
		var popup_menu = popup_node as PopupMenu
		assert(popup_menu)
		return popup_menu

	var popup_menu = PopupMenu.new()
	popup_menu.name = label
	popup_menu.hide_on_checkable_item_selection = false

	parent_popup.add_child(popup_menu)
	parent_popup.add_submenu_item(label, label)

	popup_menu.index_pressed.connect(_on_item_pressed.bind(popup_menu, path))

	return popup_menu


func _on_item_pressed(item_index, popup_menu, path):
	var item_path = path + popup_menu.get_item_text(item_index)

	if popup_menu.is_item_checkable(item_index):
		var checked = not popup_menu.is_item_checked(item_index)
		popup_menu.set_item_checked(item_index, checked)
		option_changed.emit(item_path, checked)
	else:
		option_selected.emit(item_path)
