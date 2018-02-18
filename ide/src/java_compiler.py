from PyQt5.QtCore import QProcess


class JavaCompiler:

    @staticmethod
    def run_compiler(main_window):
        process = QProcess(main_window)
        compiler_path = 'compiler/mock'
        process.start(compiler_path, [""])
        JavaCompiler.check_if_compiler_is_starting(process, main_window)

    @staticmethod
    def check_if_compiler_is_starting(process, main_window):
        if not process.waitForStarted():
            main_window.slot_write_to_console_output('Compiler is currently not implemented')
        else:
            main_window.slot_write_to_console_output('Compiler started...')
            JavaCompiler.check_if_compiler_has_finished(process, main_window)

    @staticmethod
    def check_if_compiler_has_finished(process, main_window):
        if not process.waitForFinished():
            main_window.slot_write_to_console_output('Compiler crashed in the execution')
        else:
            main_window.slot_write_to_console_output('Compiler finished!')

