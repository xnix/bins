# Bins

Versioned remote file storage writen in bash

The download and upload script transfers a directory with any number of files 
to a remote storage and keep them in a versioned directory tree.  

## Storage Structure

The structure of the file repository contains of an Id and a Version.

[bins.path]/id/major/minor/patch/[build|label/build]

### Example:

```
$ tree bins
bins
├── my-artifact
│   └── 1
│       └── 0
│           └── 1
│               ├── 23
│               │   ├── my-artifact-1.0.1-23.exe
│               │   └── my-artifact.meta.xml
│               ├── 24
│               │   ├── my-artifact-1.0.1-24.exe
│               │   └── my-artifact.meta.xml
│               └── 25
│                   ├── my-artifact-1.0.1-25.exe
│                   └── my-artifact.meta.xml
└── your-artifact
    └── 2
        └── 1
            ├── 0
            │   ├── 3
            │   │   ├── performance.report.xml
            │   │   ├── test.report.xml
            │   │   └── your-artifact-2.1.0-3.tar.gz
            │   └── 4
            │       ├── performance.report.xml
            │       ├── test.report.xml
            │       └── your-artifact-2.1.0-4.tar.gz
            └── 1
                ├── 5
                │   ├── performance.report.xml
                │   ├── test.report.xml
                │   └── your-artifact-2.1.0-5.tar.gz
                └── 6
                    ├── error.report.xml
                    ├── performance.report.xml
                    ├── test.report.xml
                    └── your-artifact-2.1.0-6.tar.gz
```

## Installation

Client must have ssh access to the Server, preferable with private/public keys.

* Download [bins.zip](https://github.com/tomas-forsman/bins/releases/download/0.5.0/bins-0.5.0.zip)
* Unzip zip to your [bins dir]
  * Example: /var/lib/bins
* Put [bins dir]/bin in your PATH
* Update [bins dir]/etc/bins.properties

## Client

* bins-upload.sh \<id\> \<version\> \<directory to upload\>
* bins-download.sh \<id\> \<version\> \<output directory\>

### Example

Store the content of 'artifact-directory' under [bins.host]:[bins.path]/my-artifact/4/1/0/2
  bins-upload.sh my-artifact 4.1.0-2 artifact-directory

Build number with dot is also supported, will store under same path: [bins.host]:[bins.path]/my-artifact/4/1/0/2
  bins-upload.sh my-artifact 4.1.0.2 artifact-directory

Version label can be used to separate builds. Storage path: [bins.host]:[bins.path]/my-artifact/4/1/0/projectA/2
  bins-upload.sh my-artifact 4.1.0-projectA.2 artifact-directory

## Server

* bins-cleanup.sh \<base.path\> \<versions to keep\>

The versions to keep parameter affects how many build numbers of every version to keep.

Recommendation is to add execution of bins-cleanup.sh to a cron job.

