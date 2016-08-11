/*
 *   Copyright 2014 David Edmundson <davidedmundson@kde.org>
 *   Copyright 2014 Aleix Pol Gonzalez <aleixpol@blue-systems.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2 or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 2.2

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents


Item {
    id: wrapper

    property bool isCurrent: ListView.isCurrentItem
    property bool isMouseOver

    property string name
    property string userName
    property string iconSource
    property int faceSize

    signal clicked()

    height: childrenRect.height
    width: childrenRect.width + 12

    Rectangle {
        id: background
        anchors.fill: parent

        color: isMouseOver && !isCurrent ? "#367CC9" : "transparent"
        opacity: 0.3
    }

    Item {
        id: imageWrapper
        anchors {
            top: parent.top
            left: parent.left
        }

        height: faceSize
        width: faceSize

        PlasmaCore.FrameSvgItem {
            id: frame
            imagePath: "widgets/background"

            //width is set in alias at top
            width: faceSize
            height: faceSize

            anchors {
                centerIn: parent
            }
        }

        //we sometimes have a path to an image sometimes an icon
        //IconItem in it's infinite wisdom tries to load a full path as an icon which is rubbish
        //we try loading it as a normal image, if that fails we fall back to IconItem
        Image {
            id: face
            source: wrapper.iconSource
            anchors {
                fill: frame
                //negative to make frame around the image
                topMargin: frame.margins.top
                leftMargin: frame.margins.left
                rightMargin: frame.margins.right
                bottomMargin: frame.margins.bottom
            }
        }


        PlasmaCore.IconItem {
            id: faceIcon
            source: wrapper.iconSource
            visible: face.status == Image.Error
            anchors.fill: face
        }
    }

    PlasmaComponents.Label {
        id: loginText
        anchors {
            left: imageWrapper.right
            leftMargin: 12
            verticalCenter: imageWrapper.verticalCenter
        }

        text: wrapper.name
        color: "white"

        font.pointSize: 14
        elide: Text.ElideRight
        wrapMode: Text.Wrap
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onClicked:  {
            wrapper.clicked();
        }

        onEntered: wrapper.isMouseOver = true
        onExited: wrapper.isMouseOver = false
    }

    Accessible.name: name
    Accessible.role: Accessible.Button
    function accessiblePressAction() { wrapper.clicked() }
}
