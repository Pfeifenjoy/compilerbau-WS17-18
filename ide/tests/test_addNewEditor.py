from addNewEditor import AddNewEditor


def test_extract_ids_from_tab_names_with_empty_list():
    tab_names = []
    expected = []
    assert AddNewEditor.extract_ids_from_tab_names(tab_names) == expected


def test_extract_ids_from_tab_names_with_mixed_strings():
    tab_names = ['Untitled-1', 'Untitled-2', 'SomeJava', 'Untitled-3']
    expected = ['1', '2', 'SomeJava', '3']
    assert AddNewEditor.extract_ids_from_tab_names(tab_names) == expected


def test_extract_ids_from_tab_names_without_untitled_strings():
    tab_names = ['Test-1', 'Test-2', 'SomeJava', 'Python-3']
    expected = tab_names
    assert AddNewEditor.extract_ids_from_tab_names(tab_names) == expected


def test_extract_ids_from_tab_names_with_only_untitled_strings():
    tab_names = ['Untitled-1', 'Untitled-2', 'Untitled-10', 'Untitled-567']
    expected = ['1', '2', '10', '567']
    assert AddNewEditor.extract_ids_from_tab_names(tab_names) == expected
