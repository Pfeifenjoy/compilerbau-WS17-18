from create_action import CreateAction


class ActionsFile:



    @staticmethod
    def add_actions_to_dictionary(main_window, dictionary):
        new_action = ActionsFile.create_new_action(main_window)
        open_action = ActionsFile.create_open_action(main_window)
        save_action = ActionsFile.create_save_action(main_window)
        save_as_action = ActionsFile.create_save_as_action(main_window)
        exit_action = ActionsFile.create_exit_action(main_window)
        close_action = ActionsFile.create_close_window_action(main_window)

        dictionary['new'] = new_action
        dictionary['open'] = open_action
        dictionary['save'] = save_action
        dictionary['save_as'] = save_as_action
        dictionary['exit'] = exit_action
        dictionary['close_window'] = close_action

        return dictionary

    @staticmethod
    def create_new_action(main_window):
        action = CreateAction.create_action(CreateAction.create_resource_path('images/tool_bar/new.png'),
                                            'New File',
                                            main_window,
                                            'Ctrl+N',
                                            'New File',
                                            main_window.slot_new)
        return action

    @staticmethod
    def create_save_action(main_window):
        action = CreateAction.create_action(CreateAction.create_resource_path('images/tool_bar/save.png'),
                                            'Save',
                                            main_window,
                                            'Ctrl+S',
                                            'Save',
                                            main_window.slot_save)
        return action

    @staticmethod
    def create_save_as_action(main_window):
        action = CreateAction.create_action(CreateAction.create_resource_path('images/tool_bar/saveAs.png'),
                                            'Save As...',
                                            main_window,
                                            'Ctrl+Shift+S',
                                            'Save As...',
                                            main_window.slot_save_as)
        return action

    @staticmethod
    def create_open_action(main_window):
        action = CreateAction.create_action(CreateAction.create_resource_path('images/tool_bar/open.png'),
                                            'Open File...',
                                            main_window,
                                            'Ctrl+O',
                                            'Open File...',
                                            main_window.slot_open)
        return action

    @staticmethod
    def create_exit_action(main_window):
        action = CreateAction.create_action(CreateAction.create_resource_path('images/tool_bar/exit.png'),
                                            'Exit',
                                            main_window,
                                            'Ctrl+Q',
                                            'Exit',
                                            main_window.slot_exit)
        return action

    @staticmethod
    def create_close_window_action(main_window):
        action = CreateAction.create_action(CreateAction.create_resource_path('images/tool_bar/close.png'),
                                            'Close Window',
                                            main_window,
                                            'Ctrl+W',
                                            'Close Window',
                                            main_window.slot_close_window)
        return action
