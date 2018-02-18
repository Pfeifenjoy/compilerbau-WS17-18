class Find:

    @staticmethod
    def find_next(tab_widget):
        current_index = tab_widget.currentIndex()
        editor = tab_widget.widget(current_index)
        editor.findNext()

    @staticmethod
    def find(tab_widget, text_to_find, options):
        current_index = tab_widget.currentIndex()
        editor = tab_widget.widget(current_index)
        editor.selectAll(False)

        regular_expression = options.get('regular_expression')
        case_sensitive = options.get('case_sensitive')
        whole_word = options.get('whole_word')
        wrap = options.get('wrap')
        forward_search = options.get('forward_search')
        line = options.get('line')
        index = options.get('index')
        show = options.get('show')
        posix = options.get('posix')

        editor.findFirst(text_to_find,
                         regular_expression,
                         case_sensitive,
                         whole_word,
                         wrap,
                         forward_search,
                         line,
                         index,
                         show,
                         posix)
