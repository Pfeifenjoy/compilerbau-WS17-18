from PyQt5.QtWidgets import QAction
from PyQt5.QtGui import QIcon
import sys
import os


class CreateAction:

    @staticmethod
    def create_action(icon_path, text, main_window,
                      shortcut, status_tip, slot):
        action = QAction(QIcon(icon_path),
                         text,
                         main_window)
        action.setShortcut(shortcut)
        action.setStatusTip(status_tip)
        action.triggered.connect(slot)
        return action

    @staticmethod
    def create_resource_path(relative_path):
        """ Get absolute path to resource, works for dev and for PyInstaller """
        try:
            # PyInstaller creates a temp folder and stores path in _MEIPASS
            base_path = sys._MEIPASS
        except Exception:
            base_path = os.path.abspath(".")

        return os.path.join(base_path, relative_path)
