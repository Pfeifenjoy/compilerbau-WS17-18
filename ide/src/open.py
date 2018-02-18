from PyQt5.QtWidgets import QFileDialog
from PyQt5.QtCore import QDir
from file import File
from addNewEditor import AddNewEditor
from tab import Tab


class Open:

    @staticmethod
    def open_file_dialog(main_window):
        caption = "Open File"
        file_filter = "Java Files (*.java)"
        file_paths, _filter = QFileDialog.getOpenFileNames(main_window,
                                                           caption,
                                                           QDir.homePath(),
                                                           file_filter)
        return file_paths

    @staticmethod
    def open(main_window, tab_widget):
        file_paths = list(Open.open_file_dialog(main_window))
        if file_paths:
            Open.check_for_open_files(tab_widget, file_paths)

    @staticmethod
    def check_for_open_files(tab_widget, file_paths):
        files_not_already_open = Tab.files_not_already_open(tab_widget,
                                                            file_paths)
        if files_not_already_open:
            file_paths = list(files_not_already_open)
            Open.open_editors(tab_widget, file_paths)
        else:
            last_open_file_path = file_paths[-1]
            Tab.search_for_file_path_and_focus(tab_widget, last_open_file_path)

    @staticmethod
    def open_editors(tab_widget, file_paths):
        file_names = File.get_file_names(file_paths)
        file_texts = Open.open_file_texts(file_paths)
        AddNewEditor.open_multiple_files(tab_widget,
                                         file_names, file_texts, file_paths)

    @staticmethod
    def open_file_texts(file_paths):
        file_texts = []
        iteration_length = range(len(file_paths))
        for file_path in iteration_length:
            file_text = Open.open_file_text(file_paths[file_path])
            file_texts.append(file_text)
        return file_texts

    @staticmethod
    def open_file_text(file_path):
        text = ''
        if file_path:
            file_to_read = open(file_path, 'r')
            text = file_to_read.read()
        return text
