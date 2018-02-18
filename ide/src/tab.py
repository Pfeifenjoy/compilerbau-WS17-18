from PyQt5.QtGui import QIcon
from PyQt5.QtCore import Qt
from create_action import CreateAction


class Tab:

    @staticmethod
    def get_current_editor(tab_widget):
        current_index = tab_widget.currentIndex()
        current_editor = tab_widget.widget(current_index)
        return current_editor

    @staticmethod
    def focus_tab(tab_widget, index):
        tab_widget.setCurrentIndex(index)

    @staticmethod
    def focus_new_tab(tab_widget):
        current_index = tab_widget.count() - 1
        tab_widget.setCurrentIndex(current_index)
        editor = tab_widget.widget(current_index)
        editor.setFocus(Qt.OtherFocusReason)

    @staticmethod
    def remove_tab(tab_bar, index):
        tab_bar.removeTab(index)

    @staticmethod
    def remove_current_tab(tab_bar):
        current_index = tab_bar.currentIndex()
        Tab.remove_tab(tab_bar, current_index)

    @staticmethod
    def get_text(tab_widget, index):
        editor = tab_widget.widget(index)
        return editor.text()

    @staticmethod
    def get_file_path(tab_widget, index):
        editor = tab_widget.widget(index)
        return editor.get_file_path()

    @staticmethod
    def is_dirty(tab_widget, index):
        editor = tab_widget.widget(index)
        editor_is_dirty = editor.get_is_dirty()
        return editor_is_dirty

    @staticmethod
    def more_than_one_tab_is_open(tab_bar):
        result = tab_bar.count() > 1
        return result

    @staticmethod
    def no_tabs_are_open(tab_bar):
        result = tab_bar.count() == 0
        return result

    @staticmethod
    def add_new_tab(tab_widget, widget, label):
        tab_widget.addTab(widget, label)

    @staticmethod
    def get_tab_names(tab_widget):
        tab_names = []
        for tab in range(tab_widget.count()):
            tab_names.append(tab_widget.tabText(tab))
        return tab_names

    @staticmethod
    def get_tab_name(tab_widget, index):
        return tab_widget.tabText(index)

    @staticmethod
    def files_not_already_open(tab_widget, file_paths):
        file_paths = set(file_paths)
        open_file_paths = Tab.create_open_file_paths(tab_widget)
        files_to_open = file_paths - open_file_paths
        return files_to_open

    @staticmethod
    def create_open_file_paths(tab_widget):
        open_file_paths = set()

        for current_tab in range(tab_widget.count()):
            current_editor = tab_widget.widget(current_tab)
            current_file_path = current_editor.get_file_path()
            open_file_paths.add(current_file_path)

        return open_file_paths

    @staticmethod
    def search_for_file_path(tab_widget, file_path_to_search):
        for current_tab in range(tab_widget.count()):
            current_editor = tab_widget.widget(current_tab)
            current_file_path = current_editor.get_file_path()
            if current_file_path == file_path_to_search:
                return current_tab
        return -1

    @staticmethod
    def search_for_file_path_and_focus(tab_widget, file_path_to_search):
        index = Tab.search_for_file_path(tab_widget, file_path_to_search)
        if Tab.is_valid_index(index):
            Tab.focus_tab(tab_widget, index)

    @staticmethod
    def is_valid_index(index):
        return index >= 0

    @staticmethod
    def set_icon_to_dirty(tab_widget, index):
        tab_widget.setTabIcon(index, QIcon(CreateAction.create_resource_path('images/tool_bar/saveAs.png')))

    @staticmethod
    def set_icon_to_not_dirty(tab_widget, index):
        tab_widget.setTabIcon(index, QIcon(''))

    @staticmethod
    def set_current_tab_icon_to_dirty(tab_widget):
        current_index = tab_widget.currentIndex()
        Tab.set_icon_to_dirty(tab_widget, current_index)

    @staticmethod
    def set_current_tab_icon_to_not_dirty(tab_widget):
        current_index = tab_widget.currentIndex()
        Tab.set_icon_to_not_dirty(tab_widget, current_index)
