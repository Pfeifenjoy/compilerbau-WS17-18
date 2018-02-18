from PyQt5.QtWidgets import QCheckBox,\
                            QGridLayout,\
                            QTabWidget,\
                            QVBoxLayout,\
                            QDialog,\
                            QLabel
from find import Find
from find_window_normal_search import FindWindowNormalSearch
from find_window_advanced_search import FindWindowAdvancedSearch


class FindWindow(QDialog):

    def __init__(self, editor_tab_widget, parent=None):
        super(FindWindow, self).__init__(parent)
        self.editor_tab_widget = editor_tab_widget

        layout = QVBoxLayout()

        self.normal_search = FindWindowNormalSearch(self.editor_tab_widget, self)
        self.tab_widget = QTabWidget(self)
        self.setup_tab_widget()

        layout.addWidget(self.tab_widget)

        self.setLayout(layout)

        self.setup()

    def setup(self):
        self.setWindowTitle('Find')

    def setup_tab_widget(self):
        self.tab_widget.addTab(self.normal_search, 'Normal')
        # advanced_search = FindWindowAdvancedSearch()
        # self.tab_widget.addTab(advanced_search, 'Advanced')

    def focus_normal_input_search(self):
        self.normal_search.focus_input()

    # def slot_text_changed(self):
    #     text_to_find = self.find_input.text()
    #     options = {
    #         'regular_expression': self.regular_expression.isChecked(),
    #         'case_sensitive': self.case_sensitive.isChecked(),
    #         'whole_word': self.whole_word.isChecked(),
    #         'wrap': self.wrap.isChecked(),
    #         'forward_search': self.forward_search.isChecked(),
    #         'line':
    #         'index':
    #         'show':
    #         'posix':
    #     }
    #
    #     Find.find(self.tab_widget, text_to_find, )

