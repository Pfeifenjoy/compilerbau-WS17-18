class AutoBraceClosing:

    @staticmethod
    def check_for_parentheses(character):
        if character == '(':
            insert_string = ')'
        elif character == '{':
            insert_string = '}'
        elif character == '[':
            insert_string = ']'
        elif character == '<':
            insert_string = '>'
        elif character == '\'':
            insert_string = '\''
        elif character == '\"':
            insert_string = '\"'
        else:
            insert_string = ''

        return insert_string
