from PyQt5.QtWidgets import QWidget, QGridLayout, QLabel, QLineEdit
from find import Find


class FindWindowNormalSearch(QWidget):

    def __init__(self, editor_tab_widget, parent=None):
        super(FindWindowNormalSearch, self).__init__(parent)
        self.editor_tab_widget = editor_tab_widget

        layout = QGridLayout(self)

        self.find_label = QLabel(self)
        self.find_label.setText('Find:')
        self.find_input = QLineEdit(self)
        self.find_input.textChanged.connect(self.slot_text_changed)
        self.find_input.returnPressed.connect(self.slot_return_pressed)

        layout.addWidget(self.find_label, 0, 0)
        layout.addWidget(self.find_input, 0, 1)

        self.setLayout(layout)

    def slot_text_changed(self):
        text_to_find = self.find_input.text()
        options = {
            'regular_expression': False,
            'case_sensitive': False,
            'whole_word': False,
            'wrap': True,
            'forward_search': True,
            'line': 0,
            'index': 0,
            'show': True,
            'posix': False
        }
        Find.find(self.editor_tab_widget, text_to_find, options)

    def slot_return_pressed(self):
        Find.find_next(self.editor_tab_widget)

    def focus_input(self):
        self.find_input.setFocus()
