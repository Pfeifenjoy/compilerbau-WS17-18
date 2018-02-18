from PyQt5.QtWidgets import QWidget


class FindWindowAdvancedSearch(QWidget):

    def __init__(self, parent=None):
        super(FindWindowAdvancedSearch, self).__init__(parent)
        layout = QGridLayout()

        self.find_label = QLabel(self)
        self.find_label.setText('Find:')
        self.find_input = QLineEdit(self)
        self.find_input.textChanged.connect(self.slot_text_changed)

        # self.find_next_button = QPushButton(self)
        # self.find_next_button.setText('Find Next')

        layout.addWidget(self.find_label, )

        self.line_label = QLabel(self)
        self.line_label.setText('Line:')
        self.line_input = QLineEdit(self)

        layout.addRow(self.line_label, self.line_input)

        self.regular_expression = QCheckBox(self)
        self.regular_expression.setText('Regular expression')

        layout.addRow(self.regular_expression)

        self.case_sensitive = QCheckBox(self)
        self.case_sensitive.setText('Case sensitive')

        layout.addRow(self.case_sensitive)

        self.whole_word = QCheckBox(self)
        self.whole_word.setText('Match whole word only')

        layout.addRow(self.whole_word)

        self.wrap = QCheckBox(self)
        self.wrap.setText('Wrap around')

        layout.addRow(self.wrap)

        self.forward_search = QCheckBox(self)
        self.forward_search.setText('Forward Search')
        self.forward_search.setChecked(True)

        layout.addRow(self.forward_search)

        self.posix = QCheckBox(self)
        self.posix.setText('Posix regex')

        layout.addRow(self.posix)

        self.setLayout(layout)
