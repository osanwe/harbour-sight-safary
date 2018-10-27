import QtQuick 2.0
import QtLocation 5.0
import QtPositioning 5.0
import Sailfish.Silica 1.0

Page {
    id: page

    allowedOrientations: Orientation.All

    Map {
        id: map
        anchors.fill: parent
        center: QtPositioning.coordinate(55.7542, 37.6221)
        zoomLevel: 14
        plugin: mapPlugin
    }

    Plugin {
        id: mapPlugin
        name: "osmscoutoffline"
    }
}
