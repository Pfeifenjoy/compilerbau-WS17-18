from create_action import CreateAction


class ActionsRun:

    @staticmethod
    def add_actions_to_dictionary(main_window, dictionary):
        find_action = ActionsRun.create_run_action(main_window)

        dictionary['run'] = find_action

        return dictionary

    @staticmethod
    def create_run_action(main_window):
        action = CreateAction.create_action(CreateAction.create_resource_path('images/tool_bar/run.png'),
                                            'Run',
                                            main_window,
                                            'Ctrl+R',
                                            'Run',
                                            main_window.slot_run)
        return action
