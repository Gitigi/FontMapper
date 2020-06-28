import QtQuick 2.0
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.3
import QtPositioning 5.14

Rectangle {
    id: rectangle
    width: 640
    height: 100
    property alias textEdit: textEdit
    property string letter: ''
    property string code
    property string font_family_input
    property string font_family_output

    RowLayout {
        id: rowLayout
        width: parent.width
        height: parent.height
        anchors.bottomMargin: 5
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.topMargin: 5

        Rectangle {
            id: rectangle2
            width: 200
            height: 200
            color: "#00000000"
            Layout.fillHeight: true
            Layout.fillWidth: true

            TextEdit {
                id: character
                x: 215
                y: 0
                width: parent.width
                height: parent.height
                text: letter
                selectByMouse: true
                readOnly: true
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: 40
                font.family: font_family_input
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }

        Rectangle {
            id: rectangle1
            width: 200
            height: 200
            color: "#00000000"
            Layout.fillHeight: true
            Layout.fillWidth: true

            TextInput {
                id: textEdit
                width: 80
                height: 20
                text: code
                activeFocusOnPress: true
                autoScroll: true
                readOnly: false
                echoMode: TextInput.Normal
                overwriteMode: false
                cursorVisible: false
                selectByMouse: true
                font.pointSize: 40
                font.family: font_family_output
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.top: parent.top
            }
        }

    }

}

/*##^##
Designer {
    D{i:1;anchors_width:100;anchors_x:187;anchors_y:225}
}
##^##*/
