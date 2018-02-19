/****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/


#pragma once

#include <QObject>
#include <QStringListModel>
#include <QUrl>
#include <QNetworkConfiguration>
#include <QNetworkConfigurationManager>
#include "QGCToolbox.h"

class WifiSetting : public QGCTool
{
    Q_OBJECT
public:
    Q_INVOKABLE void connectWifi(const QString ssid,const QString passphase);
    Q_INVOKABLE void startScan();
    Q_INVOKABLE void stopScan();

    Q_PROPERTY(QStringList  nameList    READ nameList                     NOTIFY nameListChanged)

    QStringList nameList                () { return _nameList; }

    // Override from QGCTool
    void        setToolbox          (QGCToolbox *toolbox);
public:
    WifiSetting    (QGCApplication* app, QGCToolbox* toolbox);
    ~WifiSetting   ();

signals:
    void        nameListChanged         ();
private:
    int                             _foundCount;
    QNetworkConfiguration           _netcfg;
    QStringList                     _wiFisList;
    QList<QNetworkConfiguration>    _netcfgList;

    QStringList                     _nameList;
};

