# emstudio
Engine Management Studio. Suite of desktop applications for diagnosing and tuning certain aftermarket ECU's

## Compiling

### Ubuntu 14.04 or later:

#### Install dependencies:

```
$ apt-get install git qt5-qmake qt5-default build-essential libqt5serialport5-dev libudev-dev qtdeclarative5-dev qt-quick1-5-dev qtscript5-dev libqjson-dev freeglut3-dev
```

#### Clone repository

```
$ git clone git://github.com/malcom2073/emstudio.git
$ cd emstudio
$ git submodule init
$ git submodule update
```

#### Build

```
$ qmake emstudio.pro
$ make
```

#### Run

There will be three binaries:
Tuning app: emstune/core/emstudio
Firmware loader: emsload/emsload
Log Viewer: emslogview/emslogview
