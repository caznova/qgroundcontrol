/****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/



// Allows QGlobalStatic to work on this translation unit
#define _LOG_CTOR_ACCESS_ public
#include "WifiSettings.h"
#include <QFile>
#include <QStringListModel>
#include <QtConcurrent>
#include <QTextStream>

WifiSetting::WifiSetting(QGCApplication* app, QGCToolbox* toolbox)
    : QGCTool(app, toolbox)
{

}

//-----------------------------------------------------------------------------
WifiSetting::~WifiSetting()
{

}

void WifiSetting::connectWifi(const QString ssid,const QString passphase)
{

}


void WifiSetting::startScan()
{
    QNetworkConfigurationManager ncm;
    _nameList.clear();
    emit nameListChanged();
    _netcfgList = ncm.allConfigurations();
    for (auto &x : _netcfgList)
    {
        if (x.bearerType() == QNetworkConfiguration::BearerWLAN)
        {
            if(x.name() == "")
                _nameList   += "Unknown(Other Network)";
            else
                _nameList   += x.name();
        }
    }
    emit nameListChanged();
}

void WifiSetting::stopScan()
{

}

void WifiSetting::setToolbox(QGCToolbox *toolbox)
{
    QGCTool::setToolbox(toolbox);
}
