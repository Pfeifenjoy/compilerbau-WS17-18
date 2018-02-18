from PyQt5.QtCore import QCoreApplication
from PyQt5.QtCore import QSettings


class Settings:

    settings = None

    @staticmethod
    def setup_settings():
        QCoreApplication.setOrganizationName('Grindsaw Applications')
        QCoreApplication.setApplicationName('Hypertext Phoenix')
        Settings.settings = QSettings()

    @staticmethod
    def set_font_point_size(point_size):
        Settings.settings.setValue('font_point_size', point_size)

    @staticmethod
    def get_font_point_size():
        if Settings.settings.contains('font_point_size'):
            point_size = Settings.settings.value('font_point_size', type=int)
        else:
            point_size = 12
        return point_size

    @staticmethod
    def set_font_family(family):
        Settings.settings.setValue('font_family', family)

    @staticmethod
    def get_font_family():
        if Settings.settings.contains('font_family'):
            family = Settings.settings.value('font_family', type=str)
        else:
            family = 'AnyStyle'
        return family

