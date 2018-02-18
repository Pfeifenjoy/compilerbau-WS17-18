class AutoCompletion:

    @staticmethod
    def create_auto_completion_words(lexer):
        auto_completions = []
        lexer_words = AutoCompletion.create_lexer_words(lexer)
        custom_words = AutoCompletion.create_custom_words()
        auto_completions = auto_completions + lexer_words + custom_words
        return auto_completions

    @staticmethod
    def create_lexer_words(lexer):
        keywords = lexer.keywords(1)
        auto_completion_list = []
        current_word = ''
        for character in keywords:
            if character != ' ':
                current_word = current_word + character
            else:
                auto_completion_list.append(current_word)
                current_word = ''
        return auto_completion_list

    @staticmethod
    def create_custom_words():
        custom_words = [
            'System',
            'out',
            'println'
        ]
        return custom_words

