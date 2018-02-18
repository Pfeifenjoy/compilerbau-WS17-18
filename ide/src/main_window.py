from PyQt5.QtWidgets import QMainWindow,\
                            QTabWidget,\
                            QTextEdit,\
                            QSplitter
from setup_menu_bar import SetupMenuBar
from setup_status_bar import SetupStatusBar
from setup_tool_bar import SetupToolBar
from actions import Actions
from setup_main_window import SetupMainWindow
from setup_widgets import SetupWidgets
from sys import exit
from close_window import CloseWindow
from java_compiler import JavaCompiler
from open import Open
from addNewEditor import AddNewEditor
from save import Save
from saveAs import SaveAs
from splitter import Splitter
from find_window import FindWindow
from current_editor import CurrentEditor
from settings import Settings
from settings_widget import SettingsWidget


class MainWindow(QMainWindow):

    def __init__(self):
        super().__init__()
        Settings.setup_settings()
        actions = Actions(self)
        SetupStatusBar.setup(self)
        SetupMenuBar.setup(self, actions)
        SetupToolBar.setup(self, actions)
        SetupWidgets.setup(self)
        SetupMainWindow.setup(self)

    def slot_new(self):
        tab_widget = self.get_tab_widget()
        AddNewEditor.new_editor(tab_widget)

    def slot_open(self):
        tab_widget = self.get_tab_widget()
        Open.open(self, tab_widget)

    def slot_exit(self):
        exit()

    def slot_close_window(self):
        tab_widget = self.get_tab_widget()
        current_index = tab_widget.currentIndex()
        CloseWindow.close_window(self, tab_widget, current_index)

    def slot_save(self):
        tab_widget = self.get_tab_widget()
        Save.save_current_file(self, tab_widget)

    def slot_save_as(self):
        tab_widget = self.get_tab_widget()
        SaveAs.save_current_file_as(self, tab_widget)

    def get_tab_widget(self):
        tab_widget = self.findChild(QTabWidget, 'tab_widget')
        return tab_widget

    def slot_run(self):
        JavaCompiler.run_compiler(self)

    def slot_hide_console(self):
        splitter = self.findChild(QSplitter, 'editor_console_splitter')
        Splitter.toggle_console(splitter)

    def slot_write_to_console_output(self, output):
        compile_output = self.findChild(QTextEdit, 'compile_output')
        compile_output.append(output)

    def slot_tab_close_request(self, index):
        tab_widget = self.get_tab_widget()
        CloseWindow.close_window(self, tab_widget, index)

    def slot_find(self):
        tab_widget = self.get_tab_widget()
        find_window = FindWindow(tab_widget, self)
        find_window.show()

    def slot_clear_console(self):
        compile_output = self.findChild(QTextEdit, 'compile_output')
        compile_output.clear()

    def slot_undo_current_editor(self):
        tab_widget = self.get_tab_widget()
        CurrentEditor.undo(tab_widget)

    def slot_redo_current_editor(self):
        tab_widget = self.get_tab_widget()
        CurrentEditor.redo(tab_widget)

    def slot_cut_current_editor(self):
        tab_widget = self.get_tab_widget()
        CurrentEditor.cut(tab_widget)

    def slot_copy_current_editor(self):
        tab_widget = self.get_tab_widget()
        CurrentEditor.copy(tab_widget)

    def slot_paste_current_editor(self):
        tab_widget = self.get_tab_widget()
        CurrentEditor.paste(tab_widget)

    def slot_settings(self):
        SettingsWidget.show()

    def wip(self):
        print('wip')
