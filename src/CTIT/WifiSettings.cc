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

#ifdef WIN32
#include <windows.h>
#include <wlanapi.h>
#include <objbase.h>
#include <wtypes.h>
#include <string>
#include <stdio.h>
#include <stdlib.h>

#pragma comment(lib, "wlanapi.lib")
#pragma comment(lib, "ole32.lib")


#endif

WifiSetting::WifiSetting(QGCApplication* app, QGCToolbox* toolbox)
    : QGCTool(app, toolbox),
      _connectBtn(NULL)
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
    _wifiList.clear();
    emit nameListChanged();

    if (_connectBtn){
        _connectBtn->setProperty("text", "Scaning");
        _connectBtn->setProperty("enable", "false");
    }
#ifdef WIN32
    HANDLE hClient = NULL;
    DWORD dwMaxClient = 2;
    DWORD dwCurVersion = 0;
    DWORD dwResult = 0;
    PWLAN_INTERFACE_INFO_LIST pIfList = NULL;
    LPWSTR pProfileXml = NULL;

    dwResult = WlanOpenHandle(dwMaxClient, NULL, &dwCurVersion, &hClient);
    if (dwResult != ERROR_SUCCESS) {
        //wprintf(L"WlanOpenHandle failed with error: %u\n", dwResult);
        return ;
    }

    dwResult = WlanEnumInterfaces(hClient, NULL, &pIfList);
    if (dwResult != ERROR_SUCCESS)
    {
        //wprintf(L"WlanEnumInterfaces failed with error: %u\n", dwResult);
        return ;
    }
    else
    {
        if( pIfList->dwNumberOfItems <= 0 )
        {
            if (_connectBtn){
                _connectBtn->setProperty("text", "No Wifi");
            }
            return ;
        }

        switch (pIfList->InterfaceInfo[0].isState) {
        case wlan_interface_state_not_ready:
        case wlan_interface_state_disconnecting:
        case wlan_interface_state_associating:
        case wlan_interface_state_discovering:
        case wlan_interface_state_authenticating:
        case wlan_interface_state_ad_hoc_network_formed:
            wprintf(L"Not ready\n");
            break;
        case wlan_interface_state_connected:
            wprintf(L"Connected\n");
            if (_connectBtn){
                _connectBtn->setProperty("text", "Disconnect");
                _connectBtn->setProperty("enable", "true");
            }
            break;

        case wlan_interface_state_disconnected:
            wprintf(L"Not connected\n");
            if (_connectBtn){
                _connectBtn->setProperty("text", "Connect");
                _connectBtn->setProperty("enable", "true");
            }
            break;
        default:
            //wprintf(L"Unknown state %ld\n", pIfInfo->isState);
            break;
        }

        PWLAN_AVAILABLE_NETWORK_LIST pBssList  = NULL;
        PWLAN_AVAILABLE_NETWORK pBssEntry = NULL;
        dwResult = WlanGetAvailableNetworkList(hClient, &pIfList->InterfaceInfo[0].InterfaceGuid,
                WLAN_AVAILABLE_NETWORK_INCLUDE_ALL_MANUAL_HIDDEN_PROFILES,
                NULL, &pBssList );
        if (dwResult != ERROR_SUCCESS)
        {
            WlanFreeMemory(pBssList );
            return ;
        }
        for (size_t j = 0; j < pBssList ->dwNumberOfItems; j++)
        {
            pBssEntry = (WLAN_AVAILABLE_NETWORK *) & pBssList->Network[j];

            if (pBssEntry->dot11Ssid.uSSIDLength != 0 && pBssEntry->bNetworkConnectable)
            {
                WifiObject * _wifi = new WifiObject();
                _wifi->set_ssid(QString::fromUtf8(reinterpret_cast<char *>(pBssEntry->dot11Ssid.ucSSID), pBssEntry->dot11Ssid.uSSIDLength));
                _wifi->set_secure(pBssEntry->bSecurityEnabled);
                _wifi->set_signal(pBssEntry->wlanSignalQuality);
                switch (pBssEntry->dot11DefaultAuthAlgorithm) {
                case DOT11_AUTH_ALGO_80211_OPEN:
                    _wifi->set_wifisecuretype("802.11 Open");
                    wprintf(L"802.11 Open (%u)\n", pBssEntry->dot11DefaultAuthAlgorithm);
                    break;
                case DOT11_AUTH_ALGO_80211_SHARED_KEY:
                    _wifi->set_wifisecuretype("802.11 Open");
                    break;
                case DOT11_AUTH_ALGO_WPA:
                    _wifi->set_wifisecuretype("WPA");
                    break;
                case DOT11_AUTH_ALGO_WPA_PSK:
                    _wifi->set_wifisecuretype("WPA-PSK");
                    break;
                case DOT11_AUTH_ALGO_WPA_NONE:
                    _wifi->set_wifisecuretype("WPA-None");
                    break;
                case DOT11_AUTH_ALGO_RSNA:
                    _wifi->set_wifisecuretype("RSNA");
                    break;
                case DOT11_AUTH_ALGO_RSNA_PSK:
                    _wifi->set_wifisecuretype("RSNA with PSK");
                    break;
                default:
                    _wifi->set_wifisecuretype("Other");
                    break;
                }
                _wifiList.append(_wifi);
            }
        }

        if (pProfileXml != NULL) {
            WlanFreeMemory(pProfileXml);
            pProfileXml = NULL;
        }

        if (pIfList != NULL) {
            WlanFreeMemory(pIfList);
            pIfList = NULL;
        }
    }
#else
    QNetworkConfigurationManager ncm;

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
#endif
    emit nameListChanged();
}

void WifiSetting::stopScan()
{

}

void WifiSetting::setToolbox(QGCToolbox *toolbox)
{
    QGCTool::setToolbox(toolbox);
}
