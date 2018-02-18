from actions_file import ActionsFile
from actions_view import ActionsView
from actions_edit import ActionsEdit
from actions_run import ActionsRun
from actions_settings import ActionsSettings


class Actions:

    dictionary = {}

    def __init__(self, main_window):
        self.dictionary = ActionsFile.add_actions_to_dictionary(main_window,
                                                                self.dictionary)
        self.dictionary = ActionsView.add_actions_to_dictionary(main_window,
                                                                self.dictionary)
        self.dictionary = ActionsEdit.add_actions_to_dictionary(main_window,
                                                                self.dictionary)
        self.dictionary = ActionsRun.add_actions_to_dictionary(main_window,
                                                               self.dictionary)
        self.dictionary = ActionsSettings.add_actions_to_dictionary(main_window,
                                                                    self.dictionary)

    def get_action(self, name):
        return self.dictionary[name]

