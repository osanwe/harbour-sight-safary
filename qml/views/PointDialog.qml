import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle {

    id: choiceDialog

    anchors.centerIn: parent
    width: 2 * Theme.buttonWidthSmall + 3 * Theme.paddingMedium
    height: choiceDialogContent.height + 2 * Theme.paddingMedium
    radius: 10
    color: "#EC1F1F1F"
    visible: false

    Column {
        id: choiceDialogContent
        anchors.centerIn: parent
        width: parent.width
        spacing: Theme.paddingMedium

        Label {
            id: addressLabel

            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 2 * Theme.paddingMedium
            wrapMode: Text.WordWrap
            text: coordinate.latitude + "; " + coordinate.longitude
        }

        Row {
            id: buttonsRow

            anchors.horizontalCenter: parent.horizontalCenter
            spacing: Theme.paddingMedium

            Button {
                width: Theme.buttonWidthSmall
                text: qsTr("From")

                onClicked: {
                    firstAddress.text = coordinate.latitude + "; " + coordinate.longitude
                    startCoords = coordinate
                    markerStart.coordinate = coordinate
                    markerStart.visible = true
                    choiceDialog.visible = false
                }
            }

            Button {
                width: Theme.buttonWidthSmall
                text: qsTr("To")

                onClicked: {
                    secondAddress.text = coordinate.latitude + "; " + coordinate.longitude
                    endCoords = coordinate
                    markerFinish.coordinate = coordinate
                    markerFinish.visible = true
                    choiceDialog.visible = false
                }
            }
        }
    }
}
