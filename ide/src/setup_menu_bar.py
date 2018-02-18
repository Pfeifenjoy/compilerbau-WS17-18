class SetupMenuBar:

    @staticmethod
    def setup(main_window, actions):
        menu_bar = main_window.menuBar()
        SetupMenuBar.setup_file_menu_bar(menu_bar, actions)
        SetupMenuBar.setup_edit_menu_bar(menu_bar, actions)
        SetupMenuBar.setup_run_menu_bar(menu_bar, actions)
        SetupMenuBar.setup_view_menu_bar(menu_bar, actions)
        SetupMenuBar.setup_settings_menu_bar(menu_bar, actions)

    @staticmethod
    def setup_file_menu_bar(menu_bar, actions):
        file_menu_bar = menu_bar.addMenu('File')

        new_action = actions.get_action('new')
        open_action = actions.get_action('open')
        save_action = actions.get_action('save')
        save_as_action = actions.get_action('save_as')
        close_window_action = actions.get_action('close_window')
        exit_action = actions.get_action('exit')

        file_menu_bar.addAction(new_action)
        file_menu_bar.addAction(open_action)
        file_menu_bar.addAction(save_action)
        file_menu_bar.addAction(save_as_action)
        file_menu_bar.addSeparator()
        file_menu_bar.addAction(close_window_action)
        file_menu_bar.addSeparator()
        file_menu_bar.addAction(exit_action)

    @staticmethod
    def setup_edit_menu_bar(menu_bar, actions):
        edit_menu_bar = menu_bar.addMenu('Edit')

        undo_action = actions.get_action('undo')
        redo_action = actions.get_action('redo')
        cut_action = actions.get_action('cut')
        copy_action = actions.get_action('copy')
        paste_action = actions.get_action('paste')
        find_action = actions.get_action('find')

        edit_menu_bar.addAction(undo_action)
        edit_menu_bar.addAction(redo_action)
        edit_menu_bar.addSeparator()
        edit_menu_bar.addAction(cut_action)
        edit_menu_bar.addAction(copy_action)
        edit_menu_bar.addAction(paste_action)
        edit_menu_bar.addSeparator()
        edit_menu_bar.addAction(find_action)

    @staticmethod
    def setup_run_menu_bar(menu_bar, actions):
        run_menu_bar = menu_bar.addMenu('Run')

        run_action = actions.get_action('run')

        run_menu_bar.addAction(run_action)

    @staticmethod
    def setup_view_menu_bar(menu_bar, actions):
        view_menu_bar = menu_bar.addMenu('View')

        toggle_console_action = actions.get_action('toggle_console')
        clear_console_action = actions.get_action('clear_console')

        view_menu_bar.addAction(toggle_console_action)
        view_menu_bar.addAction(clear_console_action)

    @staticmethod
    def setup_settings_menu_bar(menu_bar, actions):
        settings_menu_bar = menu_bar.addMenu('Settings')

        settings_action = actions.get_action('settings')

        settings_menu_bar.addAction(settings_action)
