import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0

import org.kde.plasma.components 2.0 as PlasmaComponents
import SddmComponents 2.0

import "components" as CustomComponents

FocusScope {
    id: root
    property alias model: usersView.model

    CustomComponents.NoiseBackground {
        anchors.fill: parent

        color: "#272727"
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#272727"
            }
            GradientStop {
                position: 1
                color: "#2b2b2b"
            }
        }

        ColumnLayout {
            anchors.centerIn: parent

            spacing: 12
            width: 600

            CustomComponents.UsersView {
                id: usersView
                height: userItemHeight
                preferredHighlightBegin: userItemWidth * 1
                preferredHighlightEnd: userItemWidth * 2
                onSelected: root.clearPassword()

                Layout.fillWidth: true
            }

            CustomComponents.HawaiiLabel {
                id: userLabel
                text: usersView.currentItem ? usersView.currentItem.name : ""
                font.pointSize: 18
                elide: Text.ElideRight
                horizontalAlignment: Qt.AlignHCenter

                Layout.fillWidth: true
            }

            CustomComponents.HawaiiPasswordField {
                id: passwordField
                width: 300
                onAccepted: root.loginRequested(usersView.currentItem.userName,
                                                passwordField.text)

                Layout.alignment: Qt.AlignHCenter
            }

            RowLayout {
                id: details
                spacing: units.largeSpacing

                CustomComponents.MessageBox {
                    id: messageBox
                }

                Item {
                    Layout.fillWidth: true
                }

                Loader {
                    sourceComponent: root.actions

                    Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                }
            }
        }

        PlasmaComponents.Label {
            id: loginUserText
            anchors {
                top: usersList.bottom
                topMargin: 12
                horizontalCenter: loginUserPicture.horizontalCenter
            }

            text: usersList.currentItem.name
            color: "white"
            font.pointSize: 20
        }

        RowLayout {
            anchors {
                right: parent.right
                rightMargin: 18
                bottom: parent.bottom
                bottomMargin: 24
            }

            spacing: 8

            PlasmaComponents.ComboBox {
                id: sessionCombo
                model: sessionModel
                currentIndex: sessionModel.lastIndex

                width: 200
                textRole: "name"

                anchors.left: parent.left
            }

            LayoutBox {
                id: layoutBox
                width: 90
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 14

                arrowIcon: "res/img/angle-down.png"
                KeyNavigation.backtab: layoutBox
                KeyNavigation.tab: btnReboot
            }

            ImageButton {
                id: btnReboot

                height: parent.height
                source: "res/img/reboot.png"

                // visible: sddm.canReboot
                onClicked: sddm.reboot()

                KeyNavigation.backtab: layoutBox
                KeyNavigation.tab: btnShutdown
            }

            ImageButton {
                id: btnShutdown
                height: parent.height - 2
                source: "res/img/shutdown.png"

                // visible: sddm.canPowerOff
                onClicked: sddm.powerOff()

                KeyNavigation.backtab: btnReboot
                KeyNavigation.tab: prevUser

                Component.onCompleted: {
                    for (var k in btnShutdown)
                        print(k, btnShutdown.k)
                }
            }
        }
    }
}
