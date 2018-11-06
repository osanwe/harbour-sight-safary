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
        plugin: mapPlugin

        MapPolyline {
            id: mapPolylineRoute
            line.color: 'green'
            line.width: 3
        }

        Component.onCompleted: {
            map.zoomLevel = 14
            map.center = QtPositioning.coordinate(55.7542, 37.6221)

            mapRouteQuery.addWaypoint(QtPositioning.coordinate(55.7542, 37.6221))
            mapRouteQuery.addWaypoint(QtPositioning.coordinate(55.7542, 37.6221))
            mapRouteModel.update()
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
