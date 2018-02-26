/****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/


import QtQuick                  2.3
import QtQuick.Controls         1.2
import QtQuick.Controls.Styles  1.4
import QtQuick.Dialogs          1.2
import QtMultimedia             5.5
import QtQuick.Layouts          1.2

import QGroundControl                       1.0
import QGroundControl.FactSystem            1.0
import QGroundControl.FactControls          1.0
import QGroundControl.Controls              1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.Palette               1.0
import QGroundControl.Controllers           1.0
import QGroundControl.SettingsManager       1.0

QGCView {
    id:                 _qgcView
    viewPanel:          panel
    color:              qgcPal.window
    anchors.fill:       parent
    anchors.margins:    ScreenTools.defaultFontPixelWidth

    property real _labelWidth:                  ScreenTools.defaultFontPixelWidth * 20
    property real _editFieldWidth:              ScreenTools.defaultFontPixelWidth * 30
    property real _panelWidth:                  _qgcView.width * _internalWidthRatio

    readonly property real _internalWidthRatio:          0.8

    QGCViewPanel {
        id:             panel
        anchors.fill:   parent
        QGCFlickable {
            clip:               true
            anchors.fill:       parent
            contentHeight:      settingsColumn.height
            contentWidth:       settingsColumn.width

            QGCLabel {
                text:       qsTr("Wifi Not Available")
                visible:    false
                anchors.centerIn: parent
            }

            Column {
                id:         settingsColumn
                spacing:    ScreenTools.defaultFontPixelHeight / 2
                visible:    true

                ExclusiveGroup { id: linkGroup }

                QGCPalette {
                    id:                 qgcPal
                    colorGroupEnabled:  enabled
                }

                QGCLabel {
                    id:     btLabel
                    text:   qsTr("Wifi Settings")
                }
                Rectangle {
                    height: 1
                    width:  btLabel.width
                    color:  qgcPal.button
                }
                Item {
                    height: ScreenTools.defaultFontPixelHeight / 2
                    width:  parent.width
                }
                Row {
                    spacing:    ScreenTools.defaultFontPixelWidth
                    QGCLabel {
                        text:   qsTr("Wifi Name:")
                        width:   (_labelWidth + _editFieldWidth) * 0.35
                    }
                    QGCTextField {
                        id:     ssidField
                        text:   ""
                        width:  (_labelWidth + _editFieldWidth) * 0.35
                        anchors.verticalCenter: parent.verticalCenter
                        readOnly: true
                        style: TextFieldStyle {
                                background: Rectangle {
                                    border.color: "#333"
                                }
                        }
                    }
                }
                Row {
                    visible:    !ScreenTools.isiOS
                    spacing:    ScreenTools.defaultFontPixelWidth
                    QGCLabel {
                        text:   qsTr("Password:")
                        width:   (_labelWidth + _editFieldWidth) * 0.35
                    }
                    QGCTextField {
                        id:     passField
                        text:   ""
                        width:  (_labelWidth + _editFieldWidth) * 0.35
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                Item {
                    height: ScreenTools.defaultFontPixelHeight / 2
                    width:  parent.width
                }
                QGCLabel {
                    text:   qsTr("Wifi Lists:")
                }
                Item {
                    width:  hostRow.width
                    height: hostRow.height
                    Row {
                        id:      hostRow
                        spacing: ScreenTools.defaultFontPixelWidth
                        Item {
                            height: 1
                            width:   (_labelWidth + _editFieldWidth) * 0.35
                        }
                        Column {
                            id:         hostColumn
                            spacing:    ScreenTools.defaultFontPixelHeight / 2
                            Rectangle {
                                height:  1
                                width:    (_labelWidth + _editFieldWidth) * 0.35
                                color:   qgcPal.button
                                visible: QGroundControl.wifiSetting.wifiList.length > 0
                            }
                            Item {
                                width:   grid.width
                                height: udpButtonRow.height
                                Row {
                                    id:         udpButtonRow
                                    spacing:    ScreenTools.defaultFontPixelWidth
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    QGCButton {
                                        width:      ScreenTools.defaultFontPixelWidth * 10
                                        text:       qsTr("Scan")
                                        enabled:    true
                                        onClicked: {
                                            QGroundControl.wifiSetting.startScan();
                                        }
                                    }
                                    QGCButton {
                                        width:      ScreenTools.defaultFontPixelWidth * 10
                                        text:       qsTr("Connect")
                                        enabled:    true
                                        onClicked: {
                                            //QGroundControl.wifiSetting.stopScan();
                                        }
                                    }
                                }
                            }
                            GridLayout {
                                   id: grid
                                   columns: 4
                                   rowSpacing: 5
                                   columnSpacing: 5
                                   width:   600
                                   anchors.leftMargin: ScreenTools.defaultFontPixelWidth * 2
                                   property var btn: QGroundControl.wifiSetting.wifiList
                                   property var sig: QGroundControl.wifiSetting.wifiList
                                   property var name: QGroundControl.wifiSetting.wifiList
                                   property var secure: QGroundControl.wifiSetting.wifiList
                                   rows: QGroundControl.wifiSetting.wifiList.length
                                   flow: GridLayout.TopToBottom
                                   height: QGroundControl.wifiSetting.wifiList.length * (ScreenTools.defaultFontPixelHeight + 20);

                                   Repeater {
                                       id: repeater
                                       model: grid.name
                                       Rectangle {
                                           Layout.row: index
                                           Layout.column: 0
                                           Layout.fillWidth: true
                                           Layout.preferredWidth: 370;
                                           Layout.fillHeight: true
                                           color: "white"
                                           property var textz: modelData.ssid
                                           Label {
                                                anchors.centerIn: parent
                                               text: parent.textz
                                           }
                                       }
                                   }
                                   Repeater {
                                       model: grid.secure
                                       Rectangle {
                                           Layout.row: index
                                           Layout.column: 1
                                           Layout.fillWidth: true
                                           Layout.preferredWidth: 100;
                                           Layout.fillHeight: true
                                           color: "white"
                                           property var textz: (modelData.secure === true ? "Secure":"" )
                                           Label {
                                                anchors.centerIn: parent
                                               text: parent.textz
                                           }
                                       }
                                   }
                                   Repeater {
                                       model: grid.sig
                                       Rectangle {
                                           Layout.row: index
                                           Layout.column: 2
                                           Layout.fillWidth: true
                                           Layout.preferredWidth: 60;
                                           Layout.fillHeight: true
                                           color: "white"
                                           property var textz: modelData.signal + "%"
                                           Label {
                                                anchors.centerIn: parent
                                               text: parent.textz
                                           }
                                       }
                                   }
                                   Repeater {
                                       model: grid.btn
                                       delegate: QGCButton {
                                           text:   "Select"
                                           Layout.row: index
                                           Layout.column: 3
                                           Layout.fillWidth: true
                                           Layout.preferredWidth: 70;
                                           Layout.fillHeight: true
                                           exclusiveGroup: linkGroup
                                           onClicked: {
                                               checked = true
                                               ssidField.text = modelData.name;
                                           }
                                       }
                                   }
                               }
                            /*
                            Repeater {
                                model: QGroundControl.wifiSetting.nameList
                                delegate:
                                QGCButton {
                                    text:   modelData
                                    width:   (_labelWidth + _editFieldWidth) * 0.35
                                    anchors.leftMargin: ScreenTools.defaultFontPixelWidth * 2
                                    exclusiveGroup: linkGroup
                                    onClicked: {
                                        checked = true
                                        ssidField.text = modelData;
                                    }
                                }
                            }
                            */
                            Rectangle {
                                height: 1
                                width:   (_labelWidth + _editFieldWidth) * 0.35
                                color:  qgcPal.button
                            }
                            Item {
                                height: ScreenTools.defaultFontPixelHeight / 2
                                width:  parent.width
                            }

                        }
                    }
                }
            }
        } // QGCFlickable
    } // QGCViewPanel
} // QGCView
