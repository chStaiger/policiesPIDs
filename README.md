# PID policies
**Authors**
- Christine Staiger (SURFsara)

**License**
Copyright 2017 SURFsara BV

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

## Synopsis

## Requirements
- iRODS 4.1.10 or higher
- PID microservices /etc/yum.repos.d/surfsara-irods.repo

## Installation and configuration of microservices
### Installation

```sh
sudo cat > /etc/yum.repos.d/surfsara-irods.repo <<EOF
[surfsara-irods]
name=Local CentOS Repo
baseurl=http://145.100.59.94/CentOS/7/irods-4.1.11/
gpgcheck=0
EOF

# check the packages
yum clean all
yum update
yum list available --disablerepo "*" --enablerepo surfsara-irods

```

Installs:

```
msiPidCreate(*path, *handle)
msiPidDelete(*path, *handle) (only for testing!)
msiPidGet(*path, *jsonPath, *result) (gets metadata stored under that PID)
msiPidGet(*path, *key, *result) (retrieves value of a Handle key)
msiPidLookup(*path, *handle) (reverse lookup for iRODS path)
msiPidMove(*pathOld, *pathNew, *handle) (Update all fields in PID related to he iRODS path)
msiPidSet(*path, *key, *value, *result) (sets an arbitrary key-value pair in the Handle system)
msiPidUnset(*path, *key, *result) (removes a key with its value from Handle system)

```

### Configuration

- Copy /etc/irods_pid.json.template to /etc/irods_pid.json and edit:
- Handle certificates
- (optional) Davrods endpoint

```
{
  "handle":{
    "url": "https://epic5.storage.surfsara.nl/api/handles",
    "port": 8003,
    "prefix": "21.T12995",

    "cert": "/etc/irods/308_21.T12995_TRAINING_certificate_only.pem",
    "key": "/etc/irods/308_21.T12995_TRAINING_privkey.pem",

    "insecure": true,
    "passphrase": null
  },
  "lookup":{
    "url": "https://epic5.storage.surfsara.nl/hrls/handles",
    "port": 8003,
    "user": "21.T12995",

    "password": "<FILLIN_PASSWORD_FOR_REVERSE_HANDLE>",

    "insecure": true,
    "limit": null,
    "page": null
  },
  "irods":{
    "server": "localhost",
    "port": 1247,
    "url_prefix": "irods://localhost",
    "webdav_prefix": "http://localhost",
    "webdav_port": 80
  }
}
```

