class AllEditors:

    @staticmethod
    def are_not_dirty(tab_widget):
        editors = AllEditors.get_all_editors(tab_widget)
        for editor in editors:
            if editors[editor].get_is_dirty:
                return False
        return True

    @staticmethod
    def get_all_editors(tab_widget):
        editors = []
        open_tabs = tab_widget.count()
        for current_tab in range(open_tabs):
            current_editor = tab_widget.widget(current_tab)
            editors.append(current_editor)
        return editors
