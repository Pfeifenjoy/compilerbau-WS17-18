from PyQt5.QtWidgets import QDialog, QSplitter, QTreeWidget, QTreeWidgetItem
from PyQt5.QtCore import Qt


class SettingsWidget:

    @staticmethod
    def show():
        dialog = QDialog()
        SettingsWidget.setup(dialog)
        # SettingsWidget.create_settings_tree(dialog)
        SettingsWidget.setup_splitter(dialog)
        dialog.exec_()

    @staticmethod
    def setup(dialog):
        dialog.setWindowTitle('Settings')

    @staticmethod
    def setup_splitter(dialog):
        splitter = QSplitter(parent=dialog, orientation=Qt.Horizontal)
        splitter.setObjectName('settings_splitter')

        settings_tree = SettingsWidget.create_settings_tree(splitter)
        splitter.addWidget(settings_tree)


        splitter.show()

        # splitter.addWidget(console)
        # splitter.setStretchFactor(0, 2)
        # splitter.setStretchFactor(1, 1)

    @staticmethod
    def create_settings_tree(splitter):
        settings_tree = QTreeWidget(splitter)
        SettingsWidget.setup_settings_tree(settings_tree)
        settings_tree.header().close()
        return settings_tree

    @staticmethod
    def setup_settings_tree(settings_tree):
        SettingsWidget.add_settings_tree_roots(settings_tree)

    @staticmethod
    def add_settings_tree_roots(settings_tree):
        font = QTreeWidgetItem(settings_tree)
        font.setText(0, 'Font')
        # SettingsWidget.add_settings_tree_child(font, 'size')
        shortcuts = QTreeWidgetItem(settings_tree)
        shortcuts.setText(0, 'shortcuts')

    @staticmethod
    def add_settings_tree_child(parent, name):
        child = QTreeWidgetItem()
        child.setText(0, name)
        parent.addChild(child)


