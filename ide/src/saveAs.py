from PyQt5.QtWidgets import QFileDialog
from PyQt5.QtCore import QDir
from tab import Tab
from file import File


class SaveAs:

    @staticmethod
    def save_current_file_as(main_window, tab_widget):
        current_index = tab_widget.currentIndex()
        SaveAs.save_as(main_window, tab_widget, current_index)

    @staticmethod
    def save_as(main_window, tab_widget, index):
        original_file_path = Tab.get_file_path(tab_widget, index)
        SaveAs.check_if_file_is_new(main_window, tab_widget, index, original_file_path)

    @staticmethod
    def check_if_file_is_new(main_window, tab_widget, index, original_file_path):
        if File.is_new(original_file_path):
            file_path = SaveAs.open_file_dialog(main_window, QDir.homePath())
        else:
            file_path = SaveAs.open_file_dialog(main_window, original_file_path)
        if file_path:
            SaveAs.get_text_and_save(tab_widget, index, file_path)

    @staticmethod
    def get_text_and_save(tab_widget, index, file_path):
        text = Tab.get_text(tab_widget, index)
        File.save(file_path, text)

    @staticmethod
    def open_file_dialog(main_window, file_path):
        caption = 'Save as ...'
        file_path, _filter = QFileDialog.getSaveFileName(main_window,
                                                         caption,
                                                         file_path)
        return file_path
