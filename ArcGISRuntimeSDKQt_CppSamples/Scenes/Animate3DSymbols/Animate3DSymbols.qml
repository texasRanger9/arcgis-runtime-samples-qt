// [WriteFile Name=Animate3DSymbols, Category=Scenes]
// [Legal]
// Copyright 2016 Esri.

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// [Legal]

import QtQuick 2.6
import QtQuick.Controls 1.4
import QtQuick.Extras 1.4
import Esri.Samples 1.0
import Esri.ArcGISExtras 1.1

Animate3DSymbolsSample {
    id: rootRectangle
    clip: true

    width: 800
    height: 600

    property double scaleFactor: System.displayScaleFactor
    property url dataPath: System.userHomePath + "/ArcGIS/Runtime/Data/3D"

    SceneView {
        id: sceneView
        objectName: "sceneView"
        anchors.fill: parent
        MouseArea {
            anchors.fill: parent
            onPressed: mouse.accepted = followButton.checked
            onWheel: wheel.accepted = followButton.checked
        }
    }

    GroupBox {
        id: animationGroupBox
        z: 110
        anchors {top: sceneView.top; left: sceneView.left; margins: 10 * scaleFactor}

        Column {
            spacing: 10

            ComboBox {
                id: missionList
                model: missionsModel()
                textRole: "display"
                onCurrentTextChanged: {
                    changeMission(currentText);
                    progressSlider.value = 0;
                }
            }

            Button {
                id: playButton
                checked: false
                checkable: true
                enabled: missionReady
                text: checked ? "pause" : "play"
            }

            Text {
                id: progressTitle
                text: "progress"
                renderType: Text.NativeRendering
            }
            Slider {
                id: progressSlider
                minimumValue: 0
                maximumValue: missionSize
                enabled : missionReady
                onValueChanged: setFrame(value);
            }

            CheckBox {
                id: followButton
                checked: true
                enabled: missionReady
                text: "follow"
                onCheckedChanged: setFollowing(checked);
            }
        }
    }

    GroupBox {
        id: cameraGroupBox
        z: 110
        anchors {top: sceneView.top; right: sceneView.right; margins: 10 * scaleFactor}

        Column {
            spacing: 10

            Text {
                id: distTitle
                text: "Zoom"
                enabled: followButton.checked && missionReady
                renderType: Text.NativeRendering
            }

            Slider {
                id: cameraDistance
                enabled: followButton.checked && missionReady
                minimumValue: 10.
                maximumValue: 500.
                value: 200.
                Component.onCompleted: setZoom(value);
                onValueChanged: setZoom(value);
            }

            Text {
                id: angleTitle
                text: "Angle"
                enabled: followButton.checked && missionReady
                renderType: Text.NativeRendering
            }

            Slider {
                id: cameraAngle
                enabled: followButton.checked && missionReady
                minimumValue: 0.
                maximumValue: 180.
                value: 75.
                Component.onCompleted: setAngle(value);
                onValueChanged: setAngle(value)
            }

            Text {
                id: speedTitle
                text: "Speed"
                enabled: missionReady
                renderType: Text.NativeRendering
            }

            Slider {
                id: animationSpeed
                enabled: missionReady
                minimumValue: 50
                maximumValue: 200
                value: 50
                Component.onCompleted: changeSpeed(value);
                onValueChanged: changeSpeed(value);
            }
        }
    }

    Rectangle {
        id: mapFrame
        anchors {left:sceneView.left; bottom: sceneView.bottom}
        width: Math.max(sceneView.width * .2, 128 * scaleFactor)
        height: Math.max(sceneView.height * .4, 128 * scaleFactor)
        color: "black"
        z: 100
        clip: true

        GroupBox {
            id: mapZoomBox
            z: 120
            anchors {top: mapFrame.top; margins: 10 * scaleFactor}
            width: mapFrame.width

            Row {
                spacing: 10

                Button {
                    id: mapZoomIn
                    anchors.margins: 10
                    text: "+"
                    width: height
                    onClicked: zoomMapIn()
                }

                Button {
                    id: mapZoomOut
                    anchors.margins: 10
                    text: "-"
                    width: height
                    onClicked: zoomMapOut()
                }
            }
        }

        MapView {
            id: mapView
            objectName: "mapView"
            anchors {fill: mapFrame; margins: 2 * scaleFactor}

            MouseArea {
                anchors.fill: parent
                onPressed: mouse.accepted
                onWheel: wheel.accepted
            }
        }
    }

    Timer {
        id: timer
        interval: 210 - animationSpeed.value; running: playButton.checked; repeat: true
        onTriggered: nextFrame();
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border {
            width: 0.5 * scaleFactor
            color: "black"
        }
    }
}
