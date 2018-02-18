from tab import Tab
from PyQt5.QtWidgets import QMessageBox


class UnsavedWarning:

    @staticmethod
    def show_unsaved_warning(tab_widget, index):
        text = UnsavedWarning.get_tab_name_and_create_unsaved_warning_text(tab_widget,
                                                                           index)

        warning_message = QMessageBox()
        warning_message.setIcon(QMessageBox.Warning)
        warning_message.setText(text)
        warning_message.setInformativeText('Your changes will be lost if you don\'t save them.')
        warning_message.setWindowTitle('Hypertext Phoenix')
        warning_message.setStandardButtons(QMessageBox.Ignore | QMessageBox.Cancel | QMessageBox.Save)
        warning_message.setDefaultButton(QMessageBox.Save)

        clicked_button = warning_message.exec_()
        button_text = UnsavedWarning.change_button_number_to_button_string(clicked_button)
        return button_text

    @staticmethod
    def change_button_number_to_button_string(button_number):
        ignore = 1048576
        cancel = 4194304
        save = 2048

        if button_number == ignore:
            text = 'ignore'
        elif button_number == cancel:
            text = 'cancel'
        elif button_number == save:
            text = 'save'
        else:
            text = 'invalid'
        return text

    @staticmethod
    def get_tab_name_and_create_unsaved_warning_text(tab_widget, index):
        tab_name = Tab.get_tab_name(tab_widget, index)
        unsaved_warning_text = UnsavedWarning.create_unsaved_warning_text(tab_name)
        return unsaved_warning_text

    @staticmethod
    def create_unsaved_warning_text(tab_name):
        beginning_text = 'Do you want to save the changes you made to '
        ending_text = '?'
        unsaved_warning_text = beginning_text + tab_name + ending_text
        return unsaved_warning_text
