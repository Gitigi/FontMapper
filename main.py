# This Python file uses the following encoding: utf-8
import sys
import os
import json

from PySide2.QtGui import QGuiApplication, QFontDatabase
from PySide2.QtQml import QQmlApplicationEngine, qmlRegisterType
from PySide2 import QtCore

from fontTools.ttLib import TTFont


class FontMapping(QtCore.QAbstractListModel):

    LetterRole = QtCore.Qt.UserRole + 1
    CodeRole = QtCore.Qt.UserRole + 2
    _COLUMNS = ('letter', 'code',)

    def __init__(self, *args, data=None, **kwargs):
        super().__init__(*args, **kwargs)
        self._data = data or []
        self._font_family = ''
        self._font_family2 = ''
        self._previous_font = []
        self._current_index = 0
        self._fonts = []

    @QtCore.Slot()
    def copy_to_clipboard(self):
        clipboard = QGuiApplication.clipboard()
        text = json.dumps(self._fonts, ensure_ascii=False)
        clipboard.setText(text)

    def roleNames(self):
        roles = super().roleNames()
        roles[FontMapping.LetterRole] = b'letter'
        roles[FontMapping.CodeRole] = b'code'
        return roles

    def rowCount(self, parent):
        return len(self._fonts) and len(self._fonts[self._current_index]['cmap'])

    def data(self, index, role):
        if role == FontMapping.LetterRole:
            return self._fonts[self._current_index]['cmap'][index.row()]['letter']
        if role == FontMapping.CodeRole:
            return self._fonts[self._current_index]['cmap'][index.row()]['code']

    @QtCore.Slot(str, result=int)
    def load_font(self, font):
        font = os.path.abspath(font.split(':')[1])
        font_db = QFontDatabase()
        font_id = font_db.addApplicationFont(font)
        families = font_db.applicationFontFamilies(font_id)

        font = TTFont(font)
        table = [{'letter': chr(ch), 'name': name, 'code': chr(ch)} for ch,name in font['cmap'].getBestCmap().items()]
        self._fonts.append({'name': families[0], 'cmap': table})

        current_index = len(self._fonts) - 1

        self.fontListChanged.emit(self.fontList)
        self._current_index = current_index
        self.reset_table()
        self.fontFamilyChanged.emit(self._font_family)
        return current_index

    def reset_table(self, data=[]):
        self.beginResetModel()
        self.endResetModel()

    @QtCore.Slot(int)
    def remove_letter(self, row):
        self.beginRemoveRows(QtCore.QModelIndex(), row, row)
        del self._fonts[self._current_index]['cmap'][row]
        self.endRemoveRows()

    @QtCore.Slot(str, str)
    def add_letter(self, letter, code):
        self.beginInsertRows(QtCore.QModelIndex(), self.rowCount(), self.rowCount())
        self._fonts[self._current_index]['cmap'].append({'letter': letter, 'code': code})
        self.endInsertRows()

    def setData(self, index, value, role):
        if role == FontMapping.CodeRole:
            self._fonts[self._current_index]['cmap'][index.row()]['code'] = value
            self.dataChanged.emit(index, index, role)
            return True
        return False

    def flags(self, index):
        return QtCore.Qt.ItemIsSelectable | QtCore.Qt.ItemIsEditable | QtCore.Qt.ItemIsEnabled

    @QtCore.Slot(int)
    def switch_font(self, index):
        if self._current_index == index:
            return
        self._current_index = index
        self.reset_table()
        self.fontFamilyChanged.emit(self._font_family)

    fontFamilyChanged = QtCore.Signal(str)

    @QtCore.Property(str, notify=fontFamilyChanged)
    def font_family(self):
        return self._fonts[self._current_index]['name']

    @font_family.setter
    def setFontFamily(self, font_family):
        if self._font_family == font_family:
            return
        self._font_family = font_family
        self.fontFamilyChanged.emit(self._font_family)

    fontFamilyChanged2 = QtCore.Signal(str)

    @QtCore.Property(str, notify=fontFamilyChanged2)
    def font_family2(self):
        return self._font_family2

    @font_family2.setter
    def setFontFamily2(self, font_family):
        if self._font_family2 == font_family:
            return
        self._font_family2 = font_family
        self.fontFamilyChanged2.emit(self._font_family2)

    fontListChanged = QtCore.Signal(str)

    @QtCore.Property('QStringList', notify=fontListChanged)
    def fontList(self):
        return [f['name'] for f in self._fonts]


    @QtCore.Property(int)
    def currentIndex(self):
        return self._current_index


if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    app.setOrganizationName('Stephen Gitigi')
    app.setOrganizationDomain('font-mapper.io')
    engine = QQmlApplicationEngine()

    context = engine.rootContext()

    qmlRegisterType(FontMapping, 'Mapper', 1, 0, 'FontMapper')

    engine.load(os.path.join(os.path.dirname(__file__), "main.qml"))
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())
