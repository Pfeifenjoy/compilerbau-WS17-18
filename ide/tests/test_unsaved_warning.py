from unsaved_warning import UnsavedWarning


def test_create_unsaved_warning_text_for_empty_name():
    tab_name = ''
    expected = 'Do you want to save the changes you made to ?'
    assert UnsavedWarning.create_unsaved_warning_text(tab_name) == expected


def test_create_unsaved_warning_text_for_untitled_one_name():
    tab_name = 'Untitled-1'
    expected = 'Do you want to save the changes you made to Untitled-1?'
    assert UnsavedWarning.create_unsaved_warning_text(tab_name) == expected


def test_create_unsaved_warning_text_for_test_name():
    tab_name = 'Test'
    expected = 'Do you want to save the changes you made to Test?'
    assert UnsavedWarning.create_unsaved_warning_text(tab_name) == expected


def test_change_button_number_to_button_string_for_ignore():
    ignore = 1048576
    expected = 'ignore'
    assert UnsavedWarning.change_button_number_to_button_string(ignore) == expected


def test_change_button_number_to_button_string_for_cancel():
    cancel = 4194304
    expected = 'cancel'
    assert UnsavedWarning.change_button_number_to_button_string(cancel) == expected


def test_change_button_number_to_button_string_for_save():
    save = 2048
    expected = 'save'
    assert UnsavedWarning.change_button_number_to_button_string(save) == expected


def test_change_button_number_to_button_string_for_invalid():
    invalid = 0
    expected = 'invalid'
    assert UnsavedWarning.change_button_number_to_button_string(invalid) == expected

