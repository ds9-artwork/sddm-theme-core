import QtQuick 2.0
import QtQuick.Controls 1.4
import QtGraphicalEffects 1.0

import SddmComponents 2.0

import "components" as CustomComponents

FocusScope {
    property alias model: usersList.model

    Rectangle {
        anchors.fill: parent
        color: "transparent"

        ListView {
            id: usersList
            width: childrenRect.width
            height: childrenRect.height

            snapMode: ListView.SnapOneItem

            signal userSelected();

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
                    width = Math.max(usersList.width, width)
                }

                onClicked: {
                    ListView.view.currentIndex = index
                    ListView.view.userSelected();
                }
            }

            highlightFollowsCurrentItem: false
            highlight: Rectangle {
                anchors.fill: ListView.view.currentItem
                color: "#367CC9"
                opacity: 0.7
            }
        }
    }
}
