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
import QtPositioning 5.0
import Sailfish.Silica 1.0

Item {
    property var coordinate: QtPositioning.coordinate(NaN, NaN)

    width: row.implicitWidth
    height: row.implicitHeight

    Row {
        id: row

        anchors.fill: parent
        spacing: Theme.paddingSmall

        Image {
            id: image

            height: column.implicitHeight
            fillMode: Image.PreserveAspectFit
            source: "../images/location.svg"
            sourceSize.height: image.height - Theme.paddingSmall * 2
        }

        Column {
            id: column

            InfoField {
                id: latitude

                key: qsTr("latitude:")
                value: coordinate.isValid ? coordinate.latitude : qsTr("...")
            }

            InfoField {
                id: longitude

                key: qsTr("longitude:")
                value: coordinate.isValid ? coordinate.longitude : qsTr("...")
            }
        }
    }
}
