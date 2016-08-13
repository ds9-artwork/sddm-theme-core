import QtQuick 2.0
import QtQuick.Controls 1.2

import SddmComponents 2.0

import "components" as CustomComponents

FocusScope {
    CustomComponents.NoiseBackground {
        anchors.fill: parent
        color: "#272727"
                gradient: Gradient {
                    GradientStop { position: 0; color: "#272727" }
                    GradientStop { position: 1; color: "#2b2b2b" }
                }

        Image {
            id: logo
            source: "res/img/maui_logo.png"
            anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
            }

            width: 400
            height: 400
        }

        Clock {
            id: clock
            anchors {
                left: parent.left
                leftMargin: 18
                bottom: parent.bottom
                bottomMargin: 24
            }
            color: "white"
            timeFont.family: "Oxygen"

            timeFont.pointSize: 64
            timeFont.letterSpacing: 20
            dateFont.pointSize: 18
            dateFont.letterSpacing: 1.5
        }

        CustomComponents.BatteryInfo {
            anchors {
                right: parent.right
                rightMargin: 18
                bottom: parent.bottom
                bottomMargin: 24
            }
        }
    }
}
