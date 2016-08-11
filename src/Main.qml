/***************************************************************************
* Copyright (c) 2013 Abdurrahman AVCI <abdurrahmanavci@gmail.com>
*
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without restriction,
* including without limitation the rights to use, copy, modify, merge,
* publish, distribute, sublicense, and/or sell copies of the Software,
* and to permit persons to whom the Software is furnished to do so,
* subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included
* in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
* OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
* OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
* ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
* OR OTHER DEALINGS IN THE SOFTWARE.
*
***************************************************************************/

import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Private 1.0 as ControlsPrivate

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

import SddmComponents 2.0

import "components" as CustomComponents

Rectangle {
    id: container
    width: 640
    height: 480

    LayoutMirroring.enabled: Qt.locale().textDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    TextConstants { id: textConstants }

    Connections {
        target: sddm

        onLoginSucceeded: {
            errorMessage.color = "steelblue"
            errorMessage.text = textConstants.loginSucceeded
        }

        onLoginFailed: {
            errorMessage.color = "red"
            errorMessage.text = textConstants.loginFailed
        }
    }

    Background {
        anchors.fill: parent
        source: config.background
        fillMode: Image.PreserveAspectCrop
        onStatusChanged: {
            if (status == Image.Error && source !== config.defaultBackground) {
                source = config.defaultBackground
            }
        }
    }

    Component {
        id: lockPage;
        LockPage {
            MouseArea {
                anchors.fill: parent
                onClicked: stack.pop();
            }

            Keys.onPressed: {
                onClicked: stack.pop();
                event.accepted = true;
            }

            // CustomComponents.FocusWatcher { target: parent }
        }
    }

    Component {
        id: loginPage;
        LoginPage {
            model: userModel
            Keys.onPressed: {
                if (event.key === Qt.Key_Escape) {
                    onClicked: stack.push({item:lockPage, properties: {focus: true}});
                    event.accepted = true
                }
            }

            // CustomComponents.FocusWatcher { target: parent }
        }
    }


    StackView {
        id: stack
        anchors.fill: parent;

        focus: true
        delegate: StackViewDelegate {
            function transitionFinished(properties)
            {
                properties.exitItem.opacity = 1
            }

            popTransition: StackViewTransition {
                PropertyAnimation {
                    target: exitItem
                    property: "y"
                    from: 0
                    to: 0 - stack.height
                }
                PropertyAnimation {
                    target: enterItem
                    property: "opacity"
                    from: 0
                    to: 1
                }
            }

            pushTransition: StackViewTransition {
                PropertyAnimation {
                    target: enterItem
                    property: "y"
                    from: 0 - stack.height
                    to: 0
                }

            }
        }

        Component.onCompleted: {
            stack.push([{"item": loginPage, "properties" : {"focus": "true"}},
                        {"item": lockPage, "properties" : {"focus": "true"}}])

        }

        // HACK REQUIRED TO RESTORE FOCUS TO THE TOP ITEM ON StackView Pop/Push
        onBusyChanged: {
            if (!stack.busy && stack.currentItem)
                stack.currentItem.focus = true
        }
    }
}
