import QtQuick 2.0
import QtLocation 5.0
import QtPositioning 5.0
import Sailfish.Silica 1.0

Page {
    id: page

    allowedOrientations: Orientation.Portrait

    Drawer {
        id: drawer

        anchors.fill: parent
        open: true

        background: Item {
            anchors.fill: parent
        }

        Map {
            id: map

            anchors.fill: parent
            plugin: mapPlugin

            MapPolyline {
                id: mapPolylineRoute
                line.color: 'green'
                line.width: 3
            }

            Component.onCompleted: {
                map.zoomLevel = 14
                map.center = QtPositioning.coordinate(55.7542, 37.6221)

                mapRouteQuery.addWaypoint(QtPositioning.coordinate(55.7708, 37.5944))
                mapRouteQuery.addWaypoint(QtPositioning.coordinate(55.7513, 37.6286))
                mapRouteModel.update()
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
