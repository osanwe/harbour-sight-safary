import QtQuick 2.0
import QtLocation 5.0
import QtPositioning 5.0
import Sailfish.Silica 1.0

Page {
    id: page

    property var coordinate
    property var startCoords
    property var endCoords

    allowedOrientations: Orientation.Portrait

    Drawer {
        id: drawer

        anchors.fill: parent
        open: true

        background: Item {
            anchors.fill: parent

            Column {
                anchors.centerIn: parent
                width: parent.width
                spacing: Theme.paddingMedium

                Label {
                    anchors.left: parent.left
                    anchors.leftMargin: Theme.horizontalPageMargin
                    text: qsTr("From:")
                    font.bold: true
                }

                Label {
                    id: firstAddress
                    width: parent.width - 2 * Theme.horizontalPageMargin
                    anchors.horizontalCenter: parent.horizontalCenter
                    wrapMode: Text.WordWrap
                }

                Label {
                    anchors.left: parent.left
                    anchors.leftMargin: Theme.horizontalPageMargin
                    text: qsTr("To:")
                    font.bold: true
                }

                Label {
                    id: secondAddress
                    width: parent.width - 2 * Theme.horizontalPageMargin
                    anchors.horizontalCenter: parent.horizontalCenter
                    wrapMode: Text.WordWrap
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: Theme.paddingMedium

                    Button {
                        width: Theme.buttonWidthSmall
                        text: qsTr("Me")
                        onClicked: {
                            map.zoomLevel = 17
                            map.center = positionSource.position.coordinate
                        }
                    }

                    Button {
                        width: Theme.buttonWidthSmall
                        text: qsTr("Navigate")
                        enabled: firstAddress.text != "" && secondAddress.text != ""
                        onClicked: {
                            mapRouteQuery.addWaypoint(startCoords)
                            mapRouteQuery.addWaypoint(endCoords)
                            mapRouteModel.update()
                        }
                    }
                }
            }
        }

        Map {
            id: map

            anchors.fill: parent
            plugin: mapPlugin

            MapPolyline {
                id: mapPolylineRoute
                line.color: Theme.highlightColor
                line.width: 5
            }

            MapQuickItem {
                id: markerStart
                visible: false
                anchorPoint.x: markerImageStart.width / 2
                anchorPoint.y: markerImageStart.height

                sourceItem: Image {
                        id: markerImageStart
                        source: "image://theme/icon-m-location?" + Theme.primaryColor
                    }
            }

            MapQuickItem {
                id: markerFinish
                visible: false
                anchorPoint.x: markerImageFinish.width / 2
                anchorPoint.y: markerImageFinish.height

                sourceItem: Image {
                        id: markerImageFinish
                        source: "image://theme/icon-m-location?" + Theme.highlightColor
                    }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (choiceDialog.visible) choiceDialog.visible = false
                    else {
                        coordinate = map.toCoordinate(Qt.point(mouse.x, mouse.y))
                        map.center = coordinate
                        choiceDialog.visible = true
                    }
                }
            }

            Rectangle {
                id: choiceDialog
                visible: false
                anchors.centerIn: parent
                width: 2 * Theme.buttonWidthSmall + 3 * Theme.paddingMedium
                height: choiceDialogContent.height + 2 * Theme.paddingMedium
                radius: 10
                color: "#EC1F1F1F"

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
                        text: coordinate.latitude + ", " + coordinate.longitude
                    }

                    Row {
                        id: buttonsRow
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: Theme.paddingMedium

                        Button {
                            width: Theme.buttonWidthSmall
                            text: qsTr("From")
                            onClicked: {
                                firstAddress.text = coordinate.latitude + ", " + coordinate.longitude
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
                                secondAddress.text = coordinate.latitude + ", " + coordinate.longitude
                                endCoords = coordinate
                                markerFinish.coordinate = coordinate
                                markerFinish.visible = true
                                choiceDialog.visible = false
                            }
                        }
                    }
                }
            }

            Component.onCompleted: {
                map.zoomLevel = 14
                map.center = QtPositioning.coordinate(55.7542, 37.6221)
            }
        }
    }

    Rectangle {

        anchors.bottom: page.bottom
        anchors.right: page.right
        anchors.bottomMargin: Theme.paddingLarge
        anchors.rightMargin: Theme.horizontalPageMargin
        width: drawerButton.width
        height: drawerButton.height
        radius: 10
        color: "#EC1F1F1F"

        IconButton {
            id: drawerButton

            anchors.centerIn: parent
            icon.source: "image://theme/icon-m-menu?" + (pressed
                                                         ? Theme.highlightColor
                                                         : Theme.primaryColor)

            onClicked: drawer.open
                       ? drawer.hide()
                       : drawer.show()
        }
    }

    Plugin {
        id: mapPlugin
        name: "osmscoutoffline"
    }

    RouteQuery {
        id: mapRouteQuery
    }

    RouteModel {
        id: mapRouteModel
        plugin: mapPlugin
        query: mapRouteQuery
        autoUpdate: false

        onRoutesChanged: mapPolylineRoute.path = mapRouteModel.get(0).path
    }
}
