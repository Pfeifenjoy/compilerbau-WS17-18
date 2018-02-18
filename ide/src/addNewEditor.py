from editor import Editor
from tab import Tab


class AddNewEditor:

    @staticmethod
    def generate_new_tab_name(tab_widget):
        tab_names = Tab.get_tab_names(tab_widget)
        ids = AddNewEditor.extract_ids_from_tab_names(tab_names)
        tab_id = 1
        while str(tab_id) in ids:
            tab_id = tab_id + 1
        tab_name = str(tab_id)
        return tab_name

    @staticmethod
    def extract_ids_from_tab_names(tab_names):
        ids = []
        for tab in range(len(tab_names)):
            tab_id = tab_names[tab].replace('Untitled-', '')
            ids.append(tab_id)
        return ids

    @staticmethod
    def open_multiple_files(tab_widget,
                            file_names, file_texts,
                            file_paths):
        iteration_length = range(len(file_paths))
        for file in iteration_length:
            AddNewEditor.open(tab_widget,
                              file_names[file], file_texts[file],
                              file_paths[file])

    @staticmethod
    def open(tab_widget, file_name, file_text, file_path):
        editor = Editor(tab_widget, file_text, file_path)
        Tab.add_new_tab(tab_widget, editor, file_name)
        Tab.focus_new_tab(tab_widget)

    @staticmethod
    def new_editor(tab_widget):
        tab_name = 'Untitled-' + AddNewEditor.generate_new_tab_name(tab_widget)
        AddNewEditor.open(tab_widget, tab_name, '', '')
