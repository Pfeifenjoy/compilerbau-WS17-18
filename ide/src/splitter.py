from PyQt5.QtWidgets import QTabWidget


class Splitter:

    @staticmethod
    def toggle_console(splitter):
        console = splitter.findChild(QTabWidget, 'console')
        if console.isHidden():
            console.show()
        else:
            console.hide()
