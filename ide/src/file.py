from PyQt5.QtCore import QFileInfo


class File:

    @staticmethod
    def get_file_names(file_paths):
        file_names = []
        iteration_length = range(len(file_paths))
        for file_path in iteration_length:
            file_info = QFileInfo(file_paths[file_path])
            file_names.append(file_info.fileName())
        return file_names

    @staticmethod
    def is_new(file_paths):
        return file_paths == ''

    @staticmethod
    def save(file_path, file_text):
        file = open(file_path, 'w')
        file.write(file_text)
        file.close()
