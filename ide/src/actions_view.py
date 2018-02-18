from create_action import CreateAction


class ActionsView:

    @staticmethod
    def add_actions_to_dictionary(main_window, dictionary):
        toggle_console_action = ActionsView.create_toggle_console_action(main_window)
        clear_console_action = ActionsView.create_clear_console_action(main_window)

        dictionary['toggle_console'] = toggle_console_action
        dictionary['clear_console'] = clear_console_action

        return dictionary

    @staticmethod
    def create_toggle_console_action(main_window):
        action = CreateAction.create_action('',
                                            'Toggle Console',
                                            main_window,
                                            'Ctrl+J',
                                            'Toggle Console',
                                            main_window.slot_hide_console)
        return action

    @staticmethod
    def create_clear_console_action(main_window):
        action = CreateAction.create_action('',
                                            'Clear Console',
                                            main_window,
                                            'Ctrl+Shift+C',
                                            'Clear Console',
                                            main_window.slot_clear_console)
        return action
