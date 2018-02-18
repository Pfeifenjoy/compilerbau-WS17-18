from create_action import CreateAction


class ActionsSettings:

    @staticmethod
    def add_actions_to_dictionary(main_window, dictionary):
        settings_action = ActionsSettings.create_settings_action(main_window)

        dictionary['settings'] = settings_action

        return dictionary

    @staticmethod
    def create_settings_action(main_window):
        action = CreateAction.create_action(CreateAction.create_resource_path('images/tool_bar/settings.png'),
                                            'Settings...',
                                            main_window,
                                            '',
                                            'Settings...',
                                            main_window.slot_settings)
        return action
