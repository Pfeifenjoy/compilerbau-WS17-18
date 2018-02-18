from file import File
from saveAs import SaveAs
from tab import Tab


class Save:

    @staticmethod
    def save(main_window, tab_widget, index):
        file_is_dirty = Tab.is_dirty(tab_widget, index)
        if file_is_dirty:
            Save.check_if_file_is_new(main_window, tab_widget, index)

    @staticmethod
    def check_if_file_is_new(main_window, tab_widget, index):
        file_path = Tab.get_file_path(tab_widget, index)

        if File.is_new(file_path):
            SaveAs.check_if_file_is_new(main_window, tab_widget, index, file_path)
        else:
            Save.get_text_and_save_file(tab_widget, file_path, index)

    @staticmethod
    def get_text_and_save_file(tab_widget, file_path, index):
        file_text = Tab.get_text(tab_widget, index)
        File.save(file_path, file_text)

    @staticmethod
    def save_current_file(main_window, tab_widget):
        current_index = tab_widget.currentIndex()
        Save.save(main_window, tab_widget, current_index)

    @staticmethod
    def save_all(main_window, tab_widget):
        for open_file in range(tab_widget.count()):
            Save.save(main_window, tab_widget, open_file)
