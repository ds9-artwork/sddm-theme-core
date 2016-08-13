import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0

import org.kde.plasma.core 2.0 as PlasmaCore
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
            id: loginAreaContainer
            anchors.centerIn: parent
            spacing: 36
            width: 600

            CustomComponents.UsersView {
                id: usersView

                height: userItemHeight
                width: userItemWidth

                Layout.alignment: Qt.AlignHCenter

                preferredHighlightBegin: userItemWidth * 1
                preferredHighlightEnd: userItemWidth * 2

                displayMarginBeginning: userItemWidth
                displayMarginEnd: userItemWidth

                highlightRangeMode: ListView.NoHighlightRange

                onSelected: root.clearPassword()

                // CustomComponents.FocusWatcher{}
            }

            CustomComponents.HawaiiLabel {
                id: userLabel
                text: usersView.currentItem ? usersView.currentItem.name : ""
                font.pointSize: 18
                elide: Text.ElideRight
                horizontalAlignment: Qt.AlignHCenter

                Layout.fillWidth: true
                // CustomComponents.FocusWatcher{}
            }

            CustomComponents.HawaiiPasswordField {
                id: passwordField
                Layout.alignment: Qt.AlignHCenter

                focus: true
                // onAccepted: root.startLogin() // onAccepted is forwarded and handled at the root item
                Keys.forwardTo: [root, usersView]
            }

/*
            Label {
                id: capsLockWarning
                text: i18nd("plasma_lookandfeel_org.kde.lookandfeel","Caps Lock is on")
                visible: keystateSource.data["Caps Lock"]["Locked"]

                //Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter

                font.weight: Font.Bold
                color: "yellow"

                PlasmaCore.DataSource {
                    id: keystateSource
                    engine: "keystate"
                    connectedSources: "Caps Lock"
                }
            }*/

            CustomComponents.MessageBox {
                id: messageBox

                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
            }
        }

        RowLayout {
            anchors {
                right: parent.right
                rightMargin: 18
                bottom: parent.bottom
                bottomMargin: 24
            }

            spacing: 12

            PlasmaComponents.ComboBox {
                id: sessionCombo
                model: sessionModel
                currentIndex: sessionModel.lastIndex

                width: 200
                textRole: "name"

                anchors.left: parent.left

                KeyNavigation.backtab: passwordField
                KeyNavigation.tab: layoutBox
            }

            LayoutBox {
                id: layoutBox
                width: 90
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 14

                arrowIcon: "res/img/angle-down.png"
                KeyNavigation.backtab: sessionCombo
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

            ColorOverlay {
                anchors.fill: btnReboot
                source: btnReboot
                color: "lightgray"
            }

            ImageButton {
                id: btnShutdown
                height: parent.height - 2
                source: "res/img/shutdown.png"

                // visible: sddm.canPowerOff
                onClicked: sddm.powerOff()

                KeyNavigation.backtab: btnReboot
                KeyNavigation.tab: passwordField

                smooth: true
            }

            ColorOverlay {
                anchors.fill: btnShutdown
                source: btnShutdown
                color: "lightgray"
            }
        }
    }

    Connections {
        target: sddm
        onLoginFailed: {
            //Re-enable button and textfield
            passwordField.enabled = true
            passwordField.selectAll()
            passwordField.forceActiveFocus()
            setErrorMessage(textConstants.loginFailed)
        }
    }

    function startLogin() {
        print("Login user")
        var username = usersView.currentItem.userName
        var password = passwordField.text
        var session = sessionCombo.currentIndex

        //Disable button and textfield while password check is running
        passwordField.enabled = false
        setInfoMessage(i18n("Verifying credentials"))

        //Clear notification in case the notificationResetTimer hasn't expired yet
        // mainItem.notification = ""
        sddm.login(username, password, session)
    }

    function clearPassword() {
        passwordField.selectAll()
        passwordField.forceActiveFocus()
    }

    function setInfoMessage(msg) {
        messageBox.setInfoMessage(msg)
    }

    function setErrorMessage(msg) {
        messageBox.setErrorMessage(msg)
    }

    Keys.onPressed: {
        if (event.key == Qt.Key_Enter || event.key == Qt.Key_Return)
            root.startLogin()
    }
}
