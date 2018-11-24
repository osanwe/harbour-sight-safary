import QtQuick 2.0
import QtLocation 5.0
import QtPositioning 5.0

import Sailfish.Silica 1.0

import "../views"

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

            MapQuickItem {
                visible: true
                anchorPoint.x: userImage.width / 2
                anchorPoint.y: userImage.height / 2
                coordinate: positionSource.position.coordinate

                sourceItem: Image {
                        id: userImage
                        source: "image://theme/icon-m-person?" + Theme.highlightColor
                    }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (choosePointDialog.visible) choosePointDialog.visible = false
                    else {
                        coordinate = map.toCoordinate(Qt.point(mouse.x, mouse.y))
                        map.center = coordinate
                        choosePointDialog.visible = true
                    }
                }
            }

            PointDialog {
                id: choosePointDialog
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

    PositionSource {
        id: positionSource
        updateInterval: 1000
        active: true
    }
}
