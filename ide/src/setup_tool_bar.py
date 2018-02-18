from PyQt5.QtWidgets import QToolBar


class SetupToolBar:

    @staticmethod
    def setup(main_window, actions):
        tool_bar = QToolBar()
        main_window.addToolBar(tool_bar)
        tool_bar.addAction(actions.get_action('new'))
        tool_bar.addAction(actions.get_action('open'))
        tool_bar.addAction(actions.get_action('save'))
        tool_bar.addAction(actions.get_action('save_as'))
        tool_bar.addSeparator()
        tool_bar.addAction(actions.get_action('undo'))
        tool_bar.addAction(actions.get_action('redo'))
        tool_bar.addSeparator()
        tool_bar.addAction(actions.get_action('cut'))
        tool_bar.addAction(actions.get_action('copy'))
        tool_bar.addAction(actions.get_action('paste'))
        tool_bar.addSeparator()
        tool_bar.addAction(actions.get_action('find'))
        tool_bar.addSeparator()
        tool_bar.addAction(actions.get_action('run'))
