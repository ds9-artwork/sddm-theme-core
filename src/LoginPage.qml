import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0

import org.kde.plasma.components 2.0 as PlasmaComponents
import SddmComponents 2.0

import "components" as CustomComponents

FocusScope {
    id: root
    property alias model: usersList.model

    Rectangle {
        anchors.fill: parent
        color: "transparent"

        ListView {
            id: usersList
            width: childrenRect.width
            height: childrenRect.height

            snapMode: ListView.SnapOneItem

            signal userSelected

            anchors {
                left: parent.left
                leftMargin: 18
                bottom: parent.bottom
                bottomMargin: 24
            }

            delegate: CustomComponents.UserDelegate {
                name: (model.realName === "") ? model.name : model.realName
                userName: model.name || ""
                iconSource: model.icon ? model.icon : "user-identity"
                faceSize: 64

                // Make all items of the same witdh
                Component.onCompleted: {
                    usersList.width = Math.max(usersList.width, width)
                    width = Qt.binding(function () {
                        return Math.max(usersList.width, width)
                    })
                }

                onClicked: {
                    ListView.view.currentIndex = index
                    ListView.view.userSelected()
                }
            }

            highlightFollowsCurrentItem: false
            highlight: Rectangle {
                anchors.fill: ListView.view.currentItem
                color: "#367CC9"
                opacity: 0.7
            }
        }

        CustomComponents.UserPicture {
            id: loginUserPicture
            anchors {
                bottom: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
            }

            faceSize: 160
            iconSource: usersList.currentItem.iconSource
        }

        PlasmaComponents.Label {
            id: loginUserText
            anchors {
                top: loginUserPicture.bottom
                topMargin: 12
                horizontalCenter: loginUserPicture.horizontalCenter
            }

            text: usersList.currentItem.name
            color: "white"
            font.pointSize: 20
        }

        ColumnLayout {
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: loginUserText.bottom
                topMargin: 12
            }
            spacing: 0
            RowLayout {

                //NOTE password is deliberately the first child so it gets focus
                //be careful when re-ordering
                anchors.horizontalCenter: parent.horizontalCenter
                PlasmaComponents.TextField {
                    id: passwordInput
                    placeholderText: i18nd(
                                         "plasma_lookandfeel_org.kde.lookandfeel",
                                         "Password")
                    echoMode: TextInput.Password
                    onAccepted: loginPrompt.startLogin()
                    focus: true

                    //focus works in qmlscene
                    //but this seems to be needed when loaded from SDDM
                    //I don't understand why, but we have seen this before in the old lock screen
                    Timer {
                        interval: 200
                        running: passwordInput.visible
                        onTriggered: passwordInput.forceActiveFocus()
                    }

                    //end hack
                    Keys.onEscapePressed: {
                        //nextItemInFocusChain(false) is previous Item
                        nextItemInFocusChain(false).forceActiveFocus()
                    }
                }

                PlasmaComponents.Button {
                    id: loginButton
                    //this keeps the buttons the same width and thus line up evenly around the centre
                    Layout.minimumWidth: passwordInput.width
                    text: i18nd("plasma_lookandfeel_org.kde.lookandfeel",
                                "Login")
                    onClicked: loginPrompt.startLogin()
                }
            }
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
