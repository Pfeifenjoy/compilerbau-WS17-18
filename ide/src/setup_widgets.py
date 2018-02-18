from PyQt5.QtWidgets import QVBoxLayout,\
                            QWidget,\
                            QTabWidget,\
                            QTextEdit,\
                            QSplitter
from PyQt5.QtCore import Qt
from addNewEditor import AddNewEditor


class SetupWidgets:

    @staticmethod
    def setup(main_window):
        widget = QWidget(main_window)
        vertical_box_layout = QVBoxLayout(widget)
        tab_widget = QTabWidget(widget)
        tab_widget.setObjectName('tab_widget')
        tab_widget.setTabsClosable(True)
        tab_widget.setMovable(True)
        tab_widget.tabCloseRequested[int].connect(main_window.slot_tab_close_request)

        console = QTabWidget(widget)
        console.setObjectName('console')
        compile_output = QTextEdit(console)
        compile_output.setObjectName('compile_output')
        compile_output.setReadOnly(True)
        console.addTab(compile_output, 'Compiler Output')

        splitter = QSplitter(Qt.Vertical)
        splitter.setObjectName('editor_console_splitter')
        splitter.addWidget(tab_widget)
        splitter.addWidget(console)
        splitter.setStretchFactor(0, 2)
        splitter.setStretchFactor(1, 1)

        vertical_box_layout.addWidget(splitter)

        main_window.setCentralWidget(widget)

        AddNewEditor.new_editor(tab_widget)
