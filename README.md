# Bins

Bash versioned file storage

## Installation

Client must have ssh access to the Server, preferable with private/public keys.

* Download latest bins-<version>.zip
* Unzip zip to custom location (Example: /var/lib/bins)
* Put <bins dir>/bin in your PATH
* Update <bins dir>/etc/bins.properties

## Usage

### Client

Use binary-upload.sh to upload files and binary-download.sh to download files.

### Server

Recommendation is to add execution of bins-cleanup.sh to a cron job.
