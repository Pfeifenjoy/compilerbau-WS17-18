from tab import Tab
from unsaved_warning import UnsavedWarning
from save import Save


class CloseWindow:

    @staticmethod
    def close_window(main_window, tab_widget, index):
        if Tab.is_dirty(tab_widget, index):
            clicked_unsaved_warning_button = UnsavedWarning.show_unsaved_warning(tab_widget, index)
            CloseWindow.check_for_clicked_unsaved_warning_button(main_window,
                                                                 tab_widget,
                                                                 index,
                                                                 clicked_unsaved_warning_button)
        else:
            Tab.remove_current_tab(tab_widget)

    @staticmethod
    def check_for_clicked_unsaved_warning_button(main_window,
                                                 tab_widget,
                                                 index,
                                                 text):
        if text == 'save':
            Save.save(main_window, tab_widget, index)
        elif text == 'ignore':
            Tab.remove_tab(tab_widget, index)



