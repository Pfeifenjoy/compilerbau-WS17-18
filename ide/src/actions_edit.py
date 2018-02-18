from create_action import CreateAction


class ActionsEdit:

    @staticmethod
    def add_actions_to_dictionary(main_window, dictionary):
        find_action = ActionsEdit.create_find_action(main_window)
        undo_action = ActionsEdit.create_undo_action(main_window)
        redo_action = ActionsEdit.create_redo_action(main_window)
        cut_action = ActionsEdit.create_cut_action(main_window)
        copy_action = ActionsEdit.create_copy_action(main_window)
        paste_action = ActionsEdit.create_paste_action(main_window)

        dictionary['find'] = find_action
        dictionary['undo'] = undo_action
        dictionary['redo'] = redo_action
        dictionary['cut'] = cut_action
        dictionary['copy'] = copy_action
        dictionary['paste'] = paste_action

        return dictionary

    @staticmethod
    def create_find_action(main_window):
        action = CreateAction.create_action(CreateAction.create_resource_path('images/tool_bar/find.png'),
                                            'Find',
                                            main_window,
                                            'Ctrl+F',
                                            'Find',
                                            main_window.slot_find)
        return action

    @staticmethod
    def create_undo_action(main_window):
        action = CreateAction.create_action(CreateAction.create_resource_path('images/tool_bar/undo.png'),
                                            'Undo',
                                            main_window,
                                            'Ctrl+Z',
                                            'Undo',
                                            main_window.slot_undo_current_editor)
        return action

    @staticmethod
    def create_redo_action(main_window):
        action = CreateAction.create_action(CreateAction.create_resource_path('images/tool_bar/redo.png'),
                                            'Redo',
                                            main_window,
                                            'Ctrl+Y',
                                            'Redo',
                                            main_window.slot_redo_current_editor)
        return action

    @staticmethod
    def create_cut_action(main_window):
        action = CreateAction.create_action(CreateAction.create_resource_path('images/tool_bar/cut.png'),
                                            'Cut',
                                            main_window,
                                            'Ctrl+X',
                                            'Cut',
                                            main_window.slot_cut_current_editor)
        return action

    @staticmethod
    def create_copy_action(main_window):
        action = CreateAction.create_action(CreateAction.create_resource_path('images/tool_bar/copy.png'),
                                            'Copy',
                                            main_window,
                                            'Ctrl+C',
                                            'Copy',
                                            main_window.slot_copy_current_editor)
        return action

    @staticmethod
    def create_paste_action(main_window):
        action = CreateAction.create_action(CreateAction.create_resource_path('images/tool_bar/paste.png'),
                                            'Paste',
                                            main_window,
                                            'Ctrl+V',
                                            'Paste',
                                            main_window.slot_paste_current_editor)
        return action
