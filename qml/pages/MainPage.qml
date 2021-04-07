/****************************************************************************
**
** Copyright (c) 2018, Petr Vytovtov <osanwevpk@gmail.com>
** All rights reserved.
**
** Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are met:
**     * Redistributions of source code must retain the above copyright
**       notice, this list of conditions and the following disclaimer.
**     * Redistributions in binary form must reproduce the above copyright
**       notice, this list of conditions and the following disclaimer in the
**       documentation and/or other materials provided with the distribution.
**     * Neither the name of the <organization> nor the
**       names of its contributors may be used to endorse or promote products
**       derived from this software without specific prior written permission.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
** AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
** IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
** ARE DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
** DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
** (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
** LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
** ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
** SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**
****************************************************************************/

import QtQuick 2.5
import QtLocation 5.0
import QtPositioning 5.0
import Sailfish.Silica 1.0
import "../views"

Page {
    id: page

    property bool mapFollowing: false
    property var mapGpsPosition: positionSource.position.coordinate
    property var mapCenterPosition: QtPositioning.coordinate(0, 0)
    property var pressCoords: QtPositioning.coordinate(0, 0)
    property var startCoords: QtPositioning.coordinate(0, 0)
    property var endCoords: QtPositioning.coordinate(0, 0)

    allowedOrientations: Orientation.Portrait

    Drawer {
        id: drawer

        anchors.fill: parent
        open: true
        backgroundSize: background.height
        background: Item {
            id: background

            anchors.fill: parent
            height: column.implicitHeight + column.anchors.topMargin + column.anchors.bottomMargin

            Column {
                id: column

                anchors {
                    fill: parent
                    margins: Theme.paddingMedium
                }
                spacing: Theme.paddingMedium
                width: parent.width

                Label {
                    text: qsTr("Route from:")
                    font.bold: true
                }

                LineTextField {
                    id: startLatitude

                    key: qsTr(" - latitude:")
                    value: qsTr("...")
                }

                LineTextField {
                    id: startLongitude

                    key: qsTr(" - longitude:")
                    value: qsTr("...")
                }

                Label {
                    text: qsTr("Route to:")
                    font.bold: true
                }

                LineTextField {
                    id: endLatitude

                    key: qsTr(" - latitude:")
                    value: qsTr("...")
                }

                LineTextField {
                    id: endLongitude

                    key: qsTr(" - longitude:")
                    value: qsTr("...")
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: Theme.paddingMedium

                    Button {
                        text: qsTr("My position")
                        enabled: mapGpsPosition.isValid
                                 && (mapGpsPosition.latitude !== mapCenterPosition.latitude
                                     || mapGpsPosition.longitude !== mapCenterPosition.longitude)
                        onClicked: map.setMapCenterFromGps()
                    }

                    Button {
                        text: qsTr("Route")
                        enabled: startLatitude.text !== "" && startLongitude.text !== ""
                                 && endLatitude.text !== "" && endLongitude.text !== ""
                        onClicked: {
                            routeLoadingIndicator.running = true
                            mapRouteQuery.clearWaypoints()
                            mapRouteQuery.addWaypoint(startCoords)
                            mapRouteQuery.addWaypoint(endCoords)
                            mapRouteModel.update()
                        }
                    }
                }
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
            onRoutesChanged: {
                routeLoadingIndicator.running = false
                mapRoute.path = mapRouteModel.get(0).path
            }
        }

        PositionSource {
            id: positionSource

            updateInterval: 1000
            active: true
            preferredPositioningMethods: PositionSource.AllPositioningMethods
        }

        Map {
            id: map

            function initMapCenter()
            {
                var moscowCenterPos = QtPositioning.coordinate(55.751244, 37.618423)
                if (mapGpsPosition.isValid) {
                    map.center = mapGpsPosition
                    mapFollowing = true
                } else {
                    map.center = moscowCenterPos
                }
                map.zoomLevel = 15
            }

            function setMapCenterFromGps()
            {
                if (mapGpsPosition.isValid) {
                    map.zoomLevel = 17
                    map.center.latitude = mapGpsPosition.latitude
                    map.center.longitude = mapGpsPosition.longitude
                    mapFollowing = true
                }
            }

            anchors.fill: parent
            plugin: mapPlugin
            onCenterChanged: {
                mapCenterPosition = center
                if (mapFollowing && center !== mapGpsPosition) {
                    mapFollowing = false
                }
            }
            Component.onCompleted: map.initMapCenter()
            onZoomLevelChanged: console.log(zoomLevel)

            MapRoute {
                id: mapRoute
            }

            MapMarker {
                id: markerStart

                visible: false
                source: "../images/location-stroked.svg"
            }

            MapMarker {
                id: markerFinish

                visible: false
                source: "../images/location-stroked.svg"
            }

            MapMarker {
                coordinate: mapGpsPosition
                visible: mapGpsPosition.isValid
                source: "../images/mylocation-stroked.svg"
            }

            Column {
                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    rightMargin: Theme.horizontalPageMargin
                }
                spacing: Theme.paddingLarge

                MapButton {
                    id: buttonZoomIn

                    icon.source: "../images/zoom-plus.svg"
                    enabled: map.zoomLevel < map.maximumZoomLevel
                    onClicked: map.zoomLevel = Math.min(map.zoomLevel + 1.0, map.maximumZoomLevel)
                }

                MapButton {
                    id: buttonZoomOut

                    icon.source: "../images/zoom-minus.svg"
                    enabled: map.zoomLevel > map.minimumZoomLevel
                    onClicked: map.zoomLevel = Math.max(map.zoomLevel - 1.0, map.minimumZoomLevel)
                }
            }

            MapButton {
                anchors {
                    bottom: parent.bottom
                    right: parent.right
                    bottomMargin: Theme.paddingLarge
                    rightMargin: Theme.horizontalPageMargin
                }
                icon.source: "image://theme/icon-m-menu"
                onClicked: drawer.open ? drawer.hide() : drawer.show()
            }

            MouseArea {
                anchors.fill: parent
                z: -1
                onClicked: {
                    if (choosePointDialog.visible) {
                        choosePointDialog.visible = false
                    } else {
                        pressCoords = map.toCoordinate(Qt.point(mouse.x, mouse.y))
                        choosePointDialog.visible = true
                    }
                }
            }

            PointDialog {
                id: choosePointDialog
            }

            BusyIndicator {
                id: routeLoadingIndicator

                anchors.centerIn: parent
                size: BusyIndicatorSize.Large
                color: Theme.rgba(Theme.darkPrimaryColor, Theme.opacityOverlay)
                running: false
            }

            Connections {
                target: page
                onMapGpsPositionChanged: {
                    if (mapFollowing) {
                        map.setMapCenterFromGps()
                    }
                }
            }
        }
    }
}
