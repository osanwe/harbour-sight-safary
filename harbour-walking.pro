#############################################################################
##
## Copyright (c) 2018, Petr Vytovtov <osanwevpk@gmail.com>
## All rights reserved.
##
## Redistribution and use in source and binary forms, with or without
## modification, are permitted provided that the following conditions are met:
##     * Redistributions of source code must retain the above copyright
##       notice, this list of conditions and the following disclaimer.
##     * Redistributions in binary form must reproduce the above copyright
##       notice, this list of conditions and the following disclaimer in the
##       documentation and/or other materials provided with the distribution.
##     * Neither the name of the <organization> nor the
##       names of its contributors may be used to endorse or promote products
##       derived from this software without specific prior written permission.
##
## THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
## AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
## IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
## ARE DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
## DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
## (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
## LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
## ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
## (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
## SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
##
#############################################################################

TARGET = harbour-walking

CONFIG += sailfishapp

SOURCES += \
    src/harbour-walking.cpp

DISTFILES += \
    qml/harbour-walking.qml \
    qml/cover/CoverPage.qml \
    qml/pages/MainPage.qml \
    qml/views/LineTextField.qml \
    qml/views/PointDialog.qml \
    qml/views/MapButton.qml \
    qml/views/MapMarker.qml \
    qml/views/MapRoute.qml \
    qml/images/harbour-sight-safary.svg \
    qml/images/location.svg \
    qml/images/location-stroked.svg \
    qml/images/mylocation.svg \
    qml/images/mylocation-stroked.svg \
    qml/images/zoom-minus.svg \
    qml/images/zoom-plus.svg \
    rpm/harbour-walking.changes.in \
    rpm/harbour-walking.changes.run.in \
    rpm/harbour-walking.spec \
    rpm/harbour-walking.yaml \
    translations/*.ts \
    harbour-walking.desktop \
    LICENSE \
    README.md

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

CONFIG += sailfishapp_i18n

TRANSLATIONS += \
    translations/harbour-walking.ts \
    translations/harbour-walking-ru.ts
