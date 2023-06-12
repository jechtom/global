# Zabbix Plugin: HP Smart Array Monitoring

Generates flat JSON array output from "ssacli" (HP Smart Storage Admin CLI). Output can be consumed in Zabbix or other monitoring.

Tested with HP Smart Array P410i on Ubuntu 22.

## Requirements

* Python 3
* Zabbix Agent 2

## Install to Zabbix Agent 2

```bash
# install 
sudo -s
pushd /etc/zabbix/zabbix_agent2.d/plugins.d/
wget https://github.com/jechtom/global/raw/master/zabbix-plugins/hp_array_info/hp_array_info.conf
wget https://github.com/jechtom/global/raw/master/zabbix-plugins/hp_array_info/hp_array_info.sh
chmod +x hp_array_info.sh
popd
sudo systemctl restart zabbix-agent2

# allow to run sudo ssacli without password for the zabbix user
echo "zabbix ALL=(root) NOPASSWD: /usr/sbin/ssacli ctrl slot=0 physicaldrive all show detail" > /etc/sudoers.d/allow-zabbix-sudo-ssacli

# test with:
sudo -u zabbix bash
zabbix_agent2 -t hp_array_info
```

## Zabbix Template

TBD

## Example Output

```json
[
    {
        "id": "0-1I:1:1",
        "controller": "Smart Array P410i in Slot 0 (Embedded)",
        "array": "Array A",
        "physicalDrive": "physicaldrive 1I:1:1",
        "port": "1I",
        "box": "1",
        "bay": "1",
        "status": "OK",
        "driveType": "Data Drive",
        "interfaceType": "SAS",
        "size": "146 GB",
        "driveExposedToOs": "False",
        "logicalPhysicalBlockSize": "512/512",
        "rotationalSpeed": "15000",
        "firmwareRevision": "HPDC",
        "serialNumber": "REDACTED",
        "wwid": "REDACTED",
        "model": "HP      REDACTED",
        "currentTemperatureC": "34",
        "maximumTemperatureC": "47",
        "phyCount": "2",
        "phyTransferRate": "6.0Gbps, Unknown",
        "phyPhysicalLinkRate": "Unknown, Unknown",
        "phyMaximumLinkRate": "Unknown, Unknown",
        "sanitizeEraseSupported": "False",
        "shingledMagneticRecordingSupport": "None"
    },
    {
        "id": "0-1I:1:2",
        "controller": "Smart Array P410i in Slot 0 (Embedded)",
        "array": "Array A",
        "physicalDrive": "physicaldrive 1I:1:2",
        "port": "1I",
        "box": "1",
        "bay": "2",
        "status": "OK",
        "driveType": "Data Drive",
        "interfaceType": "SAS",
        "size": "146 GB",
        "driveExposedToOs": "False",
        "logicalPhysicalBlockSize": "512/512",
        "rotationalSpeed": "15000",
        "firmwareRevision": "HPDC",
        "serialNumber": "PLW5B7JE",
        "wwid": "REDACTED",
        "model": "HP      REDACTED",
        "currentTemperatureC": "33",
        "maximumTemperatureC": "49",
        "phyCount": "2",
        "phyTransferRate": "6.0Gbps, Unknown",
        "phyPhysicalLinkRate": "Unknown, Unknown",
        "phyMaximumLinkRate": "Unknown, Unknown",
        "sanitizeEraseSupported": "False",
        "shingledMagneticRecordingSupport": "None"
    },
    {
        "id": "0-2I:1:5",
        "controller": "Smart Array P410i in Slot 0 (Embedded)",
        "array": "Array B",
        "physicalDrive": "physicaldrive 2I:1:5",
        "port": "2I",
        "box": "1",
        "bay": "5",
        "status": "Failed",
        "lastFailureReason": "Error saving ris",
        "driveType": "Data Drive",
        "interfaceType": "SAS",
        "size": "300 GB",
        "driveExposedToOs": "False",
        "logicalPhysicalBlockSize": "512/512",
        "rotationalSpeed": "10000",
        "firmwareRevision": "A430",
        "serialNumber": "REDACTED",
        "wwid": "REDACTED",
        "model": "HITACHI REDACTED",
        "phyCount": "2",
        "phyTransferRate": "6.0Gbps, Unknown",
        "phyPhysicalLinkRate": "Unknown, Unknown",
        "phyMaximumLinkRate": "Unknown, Unknown",
        "sanitizeEraseSupported": "False",
        "shingledMagneticRecordingSupport": "None"
    },
    {
        "id": "0-2I:1:6",
        "controller": "Smart Array P410i in Slot 0 (Embedded)",
        "array": "Array B",
        "physicalDrive": "physicaldrive 2I:1:6",
        "port": "2I",
        "box": "1",
        "bay": "6",
        "status": "OK",
        "driveType": "Data Drive",
        "interfaceType": "SAS",
        "size": "300 GB",
        "driveExposedToOs": "False",
        "logicalPhysicalBlockSize": "512/512",
        "rotationalSpeed": "10000",
        "firmwareRevision": "A4D0",
        "serialNumber": "REDACTED",
        "wwid": "REDACTED",
        "model": "HITACHI REDACTED",
        "currentTemperatureC": "32",
        "phyCount": "2",
        "phyTransferRate": "6.0Gbps, Unknown",
        "phyPhysicalLinkRate": "Unknown, Unknown",
        "phyMaximumLinkRate": "Unknown, Unknown",
        "sanitizeEraseSupported": "False",
        "shingledMagneticRecordingSupport": "None"
    }
]]
```
