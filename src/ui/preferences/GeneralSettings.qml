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

    property Fact _percentRemainingAnnounce:    QGroundControl.settingsManager.appSettings.batteryPercentRemainingAnnounce
    property Fact _savePath:                    QGroundControl.settingsManager.appSettings.savePath
    property Fact _userBrandImageIndoor:        QGroundControl.settingsManager.brandImageSettings.userBrandImageIndoor
    property Fact _userBrandImageOutdoor:       QGroundControl.settingsManager.brandImageSettings.userBrandImageOutdoor
    property real _labelWidth:                  ScreenTools.defaultFontPixelWidth * 20
    property real _editFieldWidth:              ScreenTools.defaultFontPixelWidth * 30
    property Fact _mapProvider:                 QGroundControl.settingsManager.flightMapSettings.mapProvider
    property Fact _mapType:                     QGroundControl.settingsManager.flightMapSettings.mapType
    property real _panelWidth:                  _qgcView.width * _internalWidthRatio

    readonly property real _internalWidthRatio:          0.8


    QGCPalette { id: qgcPal }

    QGCViewPanel {
        id:             panel
        anchors.fill:   parent
        QGCFlickable {
            clip:               true
            anchors.fill:       parent
            contentHeight:      settingsColumn.height
            contentWidth:       settingsColumn.width
            Column {
                id:                 settingsColumn
                width:              _qgcView.width
                spacing:            ScreenTools.defaultFontPixelHeight * 0.5
                anchors.margins:    ScreenTools.defaultFontPixelWidth

                //-----------------------------------------------------------------
                //-- Units
                Item {
                    width:                      _panelWidth
                    height:                     unitLabel.height
                    anchors.margins:            ScreenTools.defaultFontPixelWidth
                    anchors.horizontalCenter:   parent.horizontalCenter
                    visible:                    QGroundControl.settingsManager.unitsSettings.visible
                    QGCLabel {
                        id:             unitLabel
                        text:           qsTr("Units (Requires Restart)")
                        font.family:    ScreenTools.demiboldFontFamily
                    }
                }
                Rectangle {
                    height:                     unitsCol.height + (ScreenTools.defaultFontPixelHeight * 2)
                    width:                      _panelWidth
                    color:                      qgcPal.windowShade
                    anchors.margins:            ScreenTools.defaultFontPixelWidth
                    anchors.horizontalCenter:   parent.horizontalCenter
                    visible:                    QGroundControl.settingsManager.unitsSettings.visible
                    Column {
                        id:         unitsCol
                        spacing:    ScreenTools.defaultFontPixelWidth
                        anchors.centerIn: parent

                        Repeater {
                            id:     unitsRepeater
                            model:  [ QGroundControl.settingsManager.unitsSettings.distanceUnits, QGroundControl.settingsManager.unitsSettings.areaUnits, QGroundControl.settingsManager.unitsSettings.speedUnits, QGroundControl.settingsManager.unitsSettings.temperatureUnits ]

                            property var names: [ qsTr("Distance:"), qsTr("Area:"), qsTr("Speed:"), qsTr("Temperature:") ]

                            Row {
                                spacing:    ScreenTools.defaultFontPixelWidth
                                visible:    modelData.visible

                                QGCLabel {
                                    width:              _labelWidth
                                    anchors.baseline:   factCombo.baseline
                                    text:               unitsRepeater.names[index]
                                }
                                FactComboBox {
                                    id:                 factCombo
                                    width:              _editFieldWidth
                                    fact:               modelData
                                    indexModel:         false
                                }
                            }
                        }
                    }
                }

                //-----------------------------------------------------------------
                //-- Miscellaneous
                Item {
                    width:                      _panelWidth
                    height:                     miscLabel.height
                    anchors.margins:            ScreenTools.defaultFontPixelWidth
                    anchors.horizontalCenter:   parent.horizontalCenter
                    visible:                    QGroundControl.settingsManager.appSettings.visible
                    QGCLabel {
                        id:             miscLabel
                        text:           qsTr("Miscellaneous")
                        font.family:    ScreenTools.demiboldFontFamily
                    }
                }
                Rectangle {
                    height:                     miscCol.height + (ScreenTools.defaultFontPixelHeight * 2)
                    width:                      _panelWidth
                    color:                      qgcPal.windowShade
                    anchors.margins:            ScreenTools.defaultFontPixelWidth
                    anchors.horizontalCenter:   parent.horizontalCenter
                    visible:                    QGroundControl.settingsManager.appSettings.visible
                    Column {
                        id:         miscCol
                        spacing:    ScreenTools.defaultFontPixelWidth
                        anchors.centerIn: parent
                        //-----------------------------------------------------------------
                        //-- Map Provider
                        Row {
                            spacing:    ScreenTools.defaultFontPixelWidth
                            visible:    _mapProvider.visible
                            QGCLabel {
                                text:       qsTr("Map Provider:")
                                width:      _labelWidth
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            FactComboBox {
                                width:      _editFieldWidth
                                fact:       _mapProvider
                                indexModel: false
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                        //-----------------------------------------------------------------
                        //-- Map Type
                        Row {
                            spacing:    ScreenTools.defaultFontPixelWidth
                            visible:    _mapType.visible
                            QGCLabel {
                                text:               qsTr("Map Type:")
                                width:              _labelWidth
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            FactComboBox {
                                id:         mapTypes
                                width:      _editFieldWidth
                                fact:       _mapType
                                indexModel: false
                                anchors.verticalCenter: parent.verticalCenter
                                Connections {
                                    target: QGroundControl.settingsManager.flightMapSettings
                                    onMapTypeChanged: {
                                        mapTypes.model = _mapType.enumStrings
                                    }
                                }
                            }
                        }
                        //-----------------------------------------------------------------
                        //-- Clear settings
                        QGCCheckBox {
                            id:         clearCheck
                            text:       qsTr("Clear all settings on next start")
                            checked:    false
                            onClicked: {
                                checked ? clearDialog.visible = true : QGroundControl.clearDeleteAllSettingsNextBoot()
                            }
                            MessageDialog {
                                id:         clearDialog
                                visible:    false
                                icon:       StandardIcon.Warning
                                standardButtons: StandardButton.Yes | StandardButton.No
                                title:      qsTr("Clear Settings")
                                text:       qsTr("All saved settings will be reset the next time you start %1. Is this really what you want?").arg(QGroundControl.appName)
                                onYes: {
                                    QGroundControl.deleteAllSettingsNextBoot()
                                    clearDialog.visible = false
                                }
                                onNo: {
                                    clearCheck.checked  = false
                                    clearDialog.visible = false
                                }
                            }
                        }
                        //-----------------------------------------------------------------
                        //-- Battery talker
                        Row {
                            spacing:    ScreenTools.defaultFontPixelWidth
                            visible:    QGroundControl.settingsManager.appSettings.batteryPercentRemainingAnnounce.visible
                            QGCCheckBox {
                                id:                 announcePercentCheckbox
                                text:               qsTr("Announce battery lower than:")
                                checked:            _percentRemainingAnnounce.value !== 0
                                width:              (_labelWidth + _editFieldWidth) * 0.65
                                anchors.verticalCenter: parent.verticalCenter
                                onClicked: {
                                    if (checked) {
                                        _percentRemainingAnnounce.value = _percentRemainingAnnounce.defaultValueString
                                    } else {
                                        _percentRemainingAnnounce.value = 0
                                    }
                                }
                            }
                            FactTextField {
                                id:                 announcePercent
                                fact:               _percentRemainingAnnounce
                                width:              (_labelWidth + _editFieldWidth) * 0.35
                                enabled:            announcePercentCheckbox.checked
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                        //-----------------------------------------------------------------
                        //-- Virtual joystick settings
                        FactCheckBox {
                            text:       qsTr("Virtual Joystick")
                            visible:    _virtualJoystick.visible
                            fact:       _virtualJoystick

                            property Fact _virtualJoystick: QGroundControl.settingsManager.appSettings.virtualJoystick
                        }
                        //-----------------------------------------------------------------
                        //-- Default mission item altitude
                        Row {
                            spacing:    ScreenTools.defaultFontPixelWidth
                            visible:    QGroundControl.settingsManager.appSettings.defaultMissionItemAltitude.visible
                            QGCLabel {
                                anchors.verticalCenter: parent.verticalCenter
                                width:  (_labelWidth + _editFieldWidth) * 0.65
                                text:   qsTr("Default Mission Altitude:")
                            }
                            FactTextField {
                                id:     defaultItemAltitudeField
                                width:  (_labelWidth + _editFieldWidth) * 0.35
                                fact:   QGroundControl.settingsManager.appSettings.defaultMissionItemAltitude
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        //-----------------------------------------------------------------
                        //-- Mission AutoLoad
                        FactCheckBox {
                            text:       qsTr("AutoLoad Missions")
                            fact:       _autoLoad
                            visible:    _autoLoad.visible

                            property Fact _autoLoad: QGroundControl.settingsManager.appSettings.autoLoadMissions
                        }

                        //-----------------------------------------------------------------
                        //-- Save path
                        RowLayout {
                            spacing:    ScreenTools.defaultFontPixelWidth
                            visible:    _savePath.visible && !ScreenTools.isMobile

                            QGCLabel {
                                anchors.baseline:   savePathBrowse.baseline
                                text:               qsTr("File Save Path:")
                            }
                            QGCLabel {
                                anchors.baseline:       savePathBrowse.baseline
                                Layout.maximumWidth:    _panelWidth * 0.5
                                elide:                  Text.ElideMiddle
                                text:                   _savePath.rawValue === "" ? qsTr("<not set>") : _savePath.value
                            }
                            QGCButton {
                                id:         savePathBrowse
                                text:       "Browse"
                                onClicked:  savePathBrowseDialog.openForLoad()

                                QGCFileDialog {
                                    id:             savePathBrowseDialog
                                    qgcView:        _qgcView
                                    title:          qsTr("Choose the location to save files:")
                                    folder:         _savePath.rawValue
                                    selectExisting: true
                                    selectFolder:   true

                                    onAcceptedForLoad: _savePath.rawValue = file
                                }
                            }
                        }
                    }
                }

                //-----------------------------------------------------------------
                //-- RTK GPS
                Item {
                    width:                      _panelWidth
                    height:                     unitLabel.height
                    anchors.margins:            ScreenTools.defaultFontPixelWidth
                    anchors.horizontalCenter:   parent.horizontalCenter
                    visible:                    QGroundControl.settingsManager.rtkSettings.visible
                    QGCLabel {
                        id:             rtkLabel
                        text:           qsTr("RTK GPS (Requires Restart)")
                        font.family:    ScreenTools.demiboldFontFamily
                    }
                }
                Rectangle {
                    height:                     rtkGrid.height + (ScreenTools.defaultFontPixelHeight * 2)
                    width:                      _panelWidth
                    color:                      qgcPal.windowShade
                    anchors.margins:            ScreenTools.defaultFontPixelWidth
                    anchors.horizontalCenter:   parent.horizontalCenter
                    visible:                    QGroundControl.settingsManager.rtkSettings.visible
                    GridLayout {
                        id:                 rtkGrid
                        anchors.centerIn:   parent
                        columns:            2
                        rowSpacing:         ScreenTools.defaultFontPixelWidth
                        columnSpacing:      ScreenTools.defaultFontPixelWidth

                        QGCLabel {
                            text:               qsTr("Survey in accuracy:")
                        }
                        FactTextField {
                            fact:               QGroundControl.settingsManager.rtkSettings.surveyInAccuracyLimit
                        }

                        QGCLabel {
                            text:               qsTr("Minimum observation duration:")
                        }
                        FactTextField {
                            fact:               QGroundControl.settingsManager.rtkSettings.surveyInMinObservationDuration
                        }
                    }
                }

                //-----------------------------------------------------------------
                //-- Autoconnect settings
                Item {
                    width:                      _panelWidth
                    height:                     autoConnectLabel.height
                    anchors.margins:            ScreenTools.defaultFontPixelWidth
                    anchors.horizontalCenter:   parent.horizontalCenter
                    visible:                    QGroundControl.settingsManager.autoConnectSettings.visible
                    QGCLabel {
                        id:             autoConnectLabel
                        text:           qsTr("AutoConnect to the following devices:")
                        font.family:    ScreenTools.demiboldFontFamily
                    }
                }
                Rectangle {
                    height:                     autoConnectCol.height + (ScreenTools.defaultFontPixelHeight * 2)
                    width:                      _panelWidth
                    color:                      qgcPal.windowShade
                    anchors.margins:            ScreenTools.defaultFontPixelWidth
                    anchors.horizontalCenter:   parent.horizontalCenter
                    visible:                    QGroundControl.settingsManager.autoConnectSettings.visible

                    Column {
                        id:         autoConnectCol
                        spacing:    ScreenTools.defaultFontPixelWidth * 2
                        anchors.centerIn: parent

                        Row {
                            spacing: ScreenTools.defaultFontPixelWidth * 2

                            Repeater {
                                id:     autoConnectRepeater
                                model:  [ QGroundControl.settingsManager.autoConnectSettings.autoConnectPixhawk,
                                    QGroundControl.settingsManager.autoConnectSettings.autoConnectSiKRadio,
                                    QGroundControl.settingsManager.autoConnectSettings.autoConnectPX4Flow,
                                    QGroundControl.settingsManager.autoConnectSettings.autoConnectLibrePilot,
                                    QGroundControl.settingsManager.autoConnectSettings.autoConnectUDP,
                                    QGroundControl.settingsManager.autoConnectSettings.autoConnectRTKGPS
                                ]

                                property var names: [ qsTr("Pixhawk"), qsTr("SiK Radio"), qsTr("PX4 Flow"), qsTr("LibrePilot"), qsTr("UDP"), qsTr("RTK GPS") ]

                                FactCheckBox {
                                    text:       autoConnectRepeater.names[index]
                                    fact:       modelData
                                    visible:    modelData.visible
                                }
                            }
                        }

                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing:                  ScreenTools.defaultFontPixelWidth
                            visible:                  !ScreenTools.isMobile
                                                      && QGroundControl.settingsManager.autoConnectSettings.autoConnectNmeaPort.visible
                                                      && QGroundControl.settingsManager.autoConnectSettings.autoConnectNmeaBaud.visible

                            QGCLabel {
                                anchors.baseline: nmeaPortCombo.baseline
                                text:             qsTr("NMEA GPS Device:")
                                width:            _labelWidth
                            }

                            QGCComboBox {
                                id:     nmeaPortCombo
                                width:  _editFieldWidth
                                model:  ListModel {
                                            ListElement { text: "disabled" }
                                        }

                                onActivated: {
                                    if (index != -1) {
                                        QGroundControl.settingsManager.autoConnectSettings.autoConnectNmeaPort.value = textAt(index);
                                    }
                                }
                                Component.onCompleted: {
                                    for (var i in QGroundControl.linkManager.serialPorts) {
                                        nmeaPortCombo.model.append({text:QGroundControl.linkManager.serialPorts[i]})
                                    }
                                    var index = nmeaPortCombo.find(QGroundControl.settingsManager.autoConnectSettings.autoConnectNmeaPort.valueString);
                                    nmeaPortCombo.currentIndex = index;
                                }
                            }
                        }
                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing:                  ScreenTools.defaultFontPixelWidth
                            visible:                  !ScreenTools.isMobile
                                                      && QGroundControl.settingsManager.autoConnectSettings.autoConnectNmeaPort.visible
                                                      && QGroundControl.settingsManager.autoConnectSettings.autoConnectNmeaBaud.visible
                            QGCLabel {
                                anchors.baseline: nmeaBaudCombo.baseline
                                text:             qsTr("NMEA GPS Baudrate:")
                                width:            _labelWidth
                            }

                            QGCComboBox {
                                id:     nmeaBaudCombo
                                width:  _editFieldWidth
                                model:  [4800, 9600, 19200, 38400, 57600, 115200]

                                onActivated: {
                                    if (index != -1) {
                                        QGroundControl.settingsManager.autoConnectSettings.autoConnectNmeaBaud.value = textAt(index);
                                    }
                                }
                                Component.onCompleted: {
                                    var index = nmeaBaudCombo.find(QGroundControl.settingsManager.autoConnectSettings.autoConnectNmeaBaud.valueString);
                                    nmeaBaudCombo.currentIndex = index;
                                }
                            }
                        }
                    }
                }

                QGCLabel {
                    anchors.horizontalCenter:   parent.horizontalCenter
                    text:                       qsTr("Application Version: %1").arg(QGroundControl.qgcVersion)
                }
            } // settingsColumn
        } // QGCFlickable
    } // QGCViewPanel
} // QGCView
