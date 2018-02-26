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

class WifiObject : public QObject
{
    Q_OBJECT


    Q_PROPERTY(QString ssid READ get_ssid )
    Q_PROPERTY(bool secure READ get_secure )
    Q_PROPERTY(bool connected READ get_connected )
    Q_PROPERTY(int signal READ get_signal )
    Q_PROPERTY(QString wifisecuretype READ get_wifisecuretype )

public:
    QString         get_ssid(){return _ssid;}
    bool            get_secure(){return _secure;}
    bool            get_connected(){return _connected;}
    int             get_signal(){return _signal;}
    QString         get_wifisecuretype(){return _wifisecuretype;}

    void            set_ssid(QString pSsid){ _ssid = pSsid;}
    void            set_secure(bool pSecure){ _secure = pSecure;}
    void            set_connected(bool pConnected){ _connected = pConnected;}
    void            set_signal(int pSignal){ _signal = pSignal;}
    void            set_wifisecuretype(QString pWifisecuretype ){ _wifisecuretype = pWifisecuretype;}
private:
    QString         _ssid;
    bool            _secure;
    bool            _connected;
    int             _signal;
    QString         _wifisecuretype;
};


class WifiSetting : public QGCTool
{
    Q_OBJECT
public:
    Q_INVOKABLE void connectWifi(const QString ssid,const QString passphase);
    Q_INVOKABLE void startScan();
    Q_INVOKABLE void stopScan();

    Q_PROPERTY(QList<QObject*>  wifiList    READ wifiList                     NOTIFY nameListChanged)

    QList<QObject*> wifiList                () { return _wifiList; }
    // Override from QGCTool
    void        setToolbox          (QGCToolbox *toolbox);
public:
    WifiSetting    (QGCApplication* app, QGCToolbox* toolbox);
    ~WifiSetting   ();

signals:
    void        nameListChanged         ();
private:
    QNetworkConfiguration           _netcfg;
    QList<QObject*>                 _wifiList;
    QList<QNetworkConfiguration>    _netcfgList;
};

