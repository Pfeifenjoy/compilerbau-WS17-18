from auto_brace_closing import AutoBraceClosing


def test_for_parenthesis_with_parenthesis():
    character = '('
    expected = ')'
    assert AutoBraceClosing.check_for_parentheses(character) == expected


def test_for_parenthesis_with_braces():
    character = '{'
    expected = '}'
    assert AutoBraceClosing.check_for_parentheses(character) == expected


def test_for_parenthesis_with_squares():
    character = '['
    expected = ']'
    assert AutoBraceClosing.check_for_parentheses(character) == expected


def test_for_parenthesis_with_angle_brackets():
    character = '<'
    expected = '>'
    assert AutoBraceClosing.check_for_parentheses(character) == expected


def test_for_parenthesis_with_single_prime():
    character = '\''
    expected = '\''
    assert AutoBraceClosing.check_for_parentheses(character) == expected


def test_for_parenthesis_with_double_prime():
    character = '\"'
    expected = '\"'
    assert AutoBraceClosing.check_for_parentheses(character) == expected


def test_for_parenthesis_with_space_character():
    character = ' '
    expected = ''
    assert AutoBraceClosing.check_for_parentheses(character) == expected


def test_for_parenthesis_with_empty_character():
    character = ''
    expected = ''
    assert AutoBraceClosing.check_for_parentheses(character) == expected


def test_for_parenthesis_with_r_character():
    character = 'r'
    expected = ''
    assert AutoBraceClosing.check_for_parentheses(character) == expected


def test_for_parenthesis_with_g_character():
    character = 'g'
    expected = ''
    assert AutoBraceClosing.check_for_parentheses(character) == expected


def test_for_parenthesis_with_7_character():
    character = '7'
    expected = ''
    assert AutoBraceClosing.check_for_parentheses(character) == expected


def test_for_parenthesis_with_word_():
    character = 'abcdef'
    expected = ''
    assert AutoBraceClosing.check_for_parentheses(character) == expected
