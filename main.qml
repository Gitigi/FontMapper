import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import QtQuick.Templates 2.14
import QtQuick.Controls 2.13
import QtQuick.Dialogs 1.1
import Qt.labs.settings 1.0

import Mapper 1.0

ApplicationWindow {
    id: applicationWindow
    title: qsTr("Font Mapper")
    width: 700
    height: 480
    visible: true

//    menuBar: MenuBar {
//        Menu {
//            title: "File"
//            MenuItem {
//                id: home_menu
//                text: "Open..."
//            }
//            MenuItem {
//                text: "Copy To Clipboard"
//                onTriggered: table.copy_to_clipboard()
//            }
//        }
//        Menu {
//            title: "Edit"
//            MenuItem { text: "Cut" }
//            MenuItem { text: "Copy" }
//            MenuItem { text: "Paste" }
//        }
//    }

    FontMapper {
        id: table
    }

    ColumnLayout {
        id: columnLayout
        anchors.rightMargin: 10
        z: 10
        anchors.verticalCenter: parent.verticalCenter
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left

        RowLayout {
            y: 0
            Layout.topMargin: 30
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
            Text {
                id: leftlabel
                y: 8
                Layout.alignment: Qt.AlignHCenter
                font.pointSize: 16
                text: "Welcome To Font Mapper"
                Layout.fillWidth: true
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                fontSizeMode: Text.Fit
                Material.accent: Material.Green
            }


            ComboBox {
                id: comboBox
                model: table && table.fontList
                onCurrentIndexChanged: {
                    table && table.switch_font(currentIndex)
                }
            }

            Button {
                id: blue
                text: "Load Font"
                highlighted: true
                Material.accent: Material.Blue

                onClicked: font_dialog_loader.item.open()

                Loader {
                    id: font_dialog_loader
                    sourceComponent: font_dialog_comp
                }

                Component {
                    id: font_dialog_comp
                    FileDialog {
                        id: font_dialog
                        width: 500
                        height: 500
                        title: "select a file"
                        nameFilters: ["True Type Font (*.ttf)"]
                        onAccepted: {
                            let idx = table.load_font(font_dialog.fileUrls)
                            comboBox.currentIndex = idx
                        }
                    }
                }
            }
            Button {
                id: nonebutton
                text: "Output Font"
                highlighted: true
                Material.accent: Material.BlueGrey
                onClicked: {
                    font_output_dialog_loader.item.open()
                }

                Loader {
                    id: font_output_dialog_loader
                    sourceComponent: font_output_dialog_comp
                }

                Component {
                    id: font_output_dialog_comp
                    FontDialog {
                        id: font_output_dialog
                        width: 500
                        height: 500
                        title: "select a file"
                        onAccepted: {
                            table.font_family2 = font_output_dialog.font.family
                        }
                    }
                }
            }

            Button {
                id: copy_to_clipboard_button
                text: "Copy To Clipboard"
                highlighted: true
                Material.accent: Material.BlueGrey
                onClicked: {
                    table.copy_to_clipboard()
                }
            }

        }

        Rectangle {
            id: rectangle
            height: 500
            clip: true
            Layout.fillHeight: true
            Layout.fillWidth: true

            ListView {
                property string font_family_output: 'Ani'
                id: listView
                spacing: -1
                flickDeceleration: 400
                maximumFlickVelocity: 600
                anchors.fill: parent
                layer.smooth: true
                boundsMovement: Flickable.FollowBoundsBehavior
                boundsBehavior: Flickable.DragAndOvershootBounds
                keyNavigationWraps: true
                snapMode: ListView.SnapToItem
                ScrollBar.vertical: ScrollBar {
                    active: true
                }
                model: table

                delegate: Item{
                    width: listView.width
                    height: 100
                    Rectangle {
                        anchors.top: parent.top
                        width: parent.width
                        height: 2
                        color: 'black'
                    }
                    FontLetter {
                        letter: model.letter
                        code: model.code
                        font_family_input: table.font_family
                        font_family_output: table.font_family2
                        width: parent.width
                        textEdit.onTextChanged: {
                            model.code = textEdit.text
                        }
                    }
                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 2
                        color: 'black'
                    }
                }
            }
        }

    }
}


