from PyQt5.Qsci import QsciScintilla, QsciLexerJava, QsciAPIs
from PyQt5.QtGui import QColor, QFont, QFontMetrics, QIcon
from auto_completion import AutoCompletion
from tab import Tab
from auto_brace_closing import AutoBraceClosing
from settings import Settings


class Editor(QsciScintilla):

    font = QFont()
    is_dirty = False

    def __init__(self, parent, text, file_path):
        super(Editor, self).__init__(parent)
        self.SCN_CHARADDED[int].connect(self.slot_auto_complete_parenthesis)
        lexer = QsciLexerJava(self)
        self.set_font()
        self.set_indentation()
        self.set_lexer(lexer)
        self.set_auto_completion(lexer)
        self.set_caret()
        self.set_margin()
        self.set_encoding()
        self.deactivate_horizontal_scrollbar()
        self.set_brace_matching()
        self.set_wrapping()
        self.setWindowFilePath(file_path)
        self.setText(text)
        self.textChanged.connect(self.slot_text_changed)
        self.showMaximized()

    def slot_text_changed(self):
        if not self.is_dirty:
            self.set_is_dirty(True)
            Tab.set_current_tab_icon_to_dirty(self.parentWidget().parentWidget())

    def get_current_line_number(self):
        cursor_position = self.CurrentPosition
        return self.LineFromPosition(cursor_position) + 1

    def slot_auto_complete_parenthesis(self, charadded):
        insert_string = AutoBraceClosing.check_for_parentheses(chr(charadded))
        self.append_closing_bracket(insert_string)

    def append_closing_bracket(self, insert_string):
        if insert_string != '':
            self.insert(insert_string)

    def set_font(self):
        family = Settings.get_font_family()
        point_size = Settings.get_font_point_size()

        self.font.setFamily(family)
        self.font.setFixedPitch(True)
        self.font.setPointSize(point_size)
        self.setFont(self.font)
        self.setMarginsFont(self.font)

    def set_indentation(self):
        self.setAutoIndent(True)
        self.setIndentationGuides(True)

    def set_lexer(self, lexer):
        lexer.setDefaultFont(self.font)
        self.setLexer(lexer)

    def set_auto_completion(self, lexer):
        api = QsciAPIs(lexer)
        auto_completions = AutoCompletion.create_auto_completion_words(lexer)
        for auto_complete_word in auto_completions:
            api.add(auto_complete_word)
        api.prepare()

        self.setAutoCompletionSource(QsciScintilla.AcsAll)
        self.setAutoCompletionReplaceWord(True)
        self.setAutoCompletionUseSingle(QsciScintilla.AcusNever)
        self.setAutoCompletionCaseSensitivity(False)
        self.setAutoCompletionThreshold(1)
        self.autoCompleteFromAll()

    def set_caret(self):
        self.setCaretLineBackgroundColor(QColor('#EEEEEE'))
        self.setCaretLineVisible(True)

    def set_margin(self):
        font_metrics = QFontMetrics(self.font)
        self.setMarginsFont(self.font)
        self.setMarginWidth(0, font_metrics.width("00000") + 6)
        self.setMarginLineNumbers(0, True)
        self.setMarginsBackgroundColor(QColor("#cccccc"))

    def set_encoding(self):
        self.setUtf8(True)

    def deactivate_horizontal_scrollbar(self):
        self.SendScintilla(QsciScintilla.SCI_SETHSCROLLBAR, 0)

    def set_brace_matching(self):
        self.setBraceMatching(QsciScintilla.SloppyBraceMatch)

    def set_wrapping(self):
        self.setWrapMode(QsciScintilla.WrapWord)
        self.setWrapVisualFlags(QsciScintilla.WrapFlagInMargin)

    def set_is_dirty(self, set_to_boolean):
        self.is_dirty = set_to_boolean

    def get_is_dirty(self):
        return self.is_dirty

    def get_file_path(self):
        return self.windowFilePath()

    def reset_icon(self):
        self.setWindowIcon(QIcon())
