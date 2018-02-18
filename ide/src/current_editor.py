from tab import Tab


class CurrentEditor:

    @staticmethod
    def undo(tab_widget):
        current_editor = Tab.get_current_editor(tab_widget)
        current_editor.undo()

    @staticmethod
    def redo(tab_widget):
        current_editor = Tab.get_current_editor(tab_widget)
        current_editor.redo()

    @staticmethod
    def cut(tab_widget):
        current_editor = Tab.get_current_editor(tab_widget)
        current_editor.cut()

    @staticmethod
    def copy(tab_widget):
        current_editor = Tab.get_current_editor(tab_widget)
        current_editor.copy()

    @staticmethod
    def paste(tab_widget):
        current_editor = Tab.get_current_editor(tab_widget)
        current_editor.paste()
