# lf - lIVE fRAMEWORK
[![GitHub license](https://img.shields.io/badge/license-New%20BSD-blue.svg)](https://raw.githubusercontent.com/shogo4405/lf.swift/master/LICENSE.txt)

Camera and Microphone streaming library via RTMP, HLS for iOS, macOS.

## Features
### RTMP
- [x] Authentication
- [x] Publish and Recording (H264/AAC)
- [ ] Playback
- [x] AMF0
- [ ] AMF3
- [x] SharedObject
- [x] RTMPS
 - [x] Native (RTMP over SSL/TSL)
 - [ ] Tunneled (RTMPT over SSL/TSL) (Technical Preview)
- [ ] _RTMPT (Technical Preview)_
- [ ] _ReplayKit Live as a Broadcast Upload Extension (Technical Preview)_

### HLS
- [x] HTTPService
- [x] HLS Publish

### Others
- [x] Hardware acceleration for H264 video encoding/AAC audio encoding
- [ ] Objectiv-C Bridging

## Requirements
* iOS 8.0+
* macOS 10.11+
* xcode 8.0+

## Requirements Cocoa Keys
iOS10.0+
* NSMicrophoneUsageDescription
* NSCameraUsageDescription

## Installation
### CocoaPods
```rb
source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!

def import_pods
    pod 'lf', '~> 0.5.0'
end

target 'Your Target'  do
    platform :ios, '8.0'
    import_pods
end
```

## RTMP Usage
Real Time Messaging Protocol (RTMP).
```swift
var rtmpConnection:RTMPConnection = RTMPConnection()
var rtmpStream:RTMPStream = RTMPStream(connection: rtmpConnection)
rtmpStream.attach(audio: AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio))
rtmpStream.attach(camera: DeviceUtil.device(withPosition: .Back))

var lfView:LFView = LFView(frame: view.bounds)
lfView.videoGravity = AVLayerVideoGravityResizeAspectFill
lfView.attach(stream: rtmpStream)

// add ViewController#view
view.addSubview(lfView)

rtmpConnection.connect("rtmp://localhost/appName/instanceName")
rtmpStream.publish("streamName")
// if you want to record a stream.
// rtmpStream.publish("streamName", withType: .LocalRecord)
```
### Settings
```swift
var rtmpStream:RTMPStream = RTMPStream(connection: rtmpConnection)
rtmpStream.captureSettings = [
    "fps": 30, // FPS
    "sessionPreset": AVCaptureSessionPresetMedium, // input video width/height
    "continuousAutofocus": false, // use camera autofocus mode
    "continuousExposure": false, //  use camera exposure mode
]
rtmpStream.audioSettings = [
    "muted": false, // mute audio
    "bitrate": 32 * 1024,
]
rtmpStream.videoSettings = [
    "width": 640, // video output width
    "height": 360, // video output height
    "bitrate": 160 * 1024, // video output bitrate
    // "dataRateLimits": [160 * 1024 / 8, 1], optional kVTCompressionPropertyKey_DataRateLimits property
    "profileLevel": kVTProfileLevel_H264_Baseline_3_1, // H264 Profile require "import VideoToolbox"
    "maxKeyFrameIntervalDuration": 2, // key frame / sec
]
// "0" means the same of input
rtmpStream.recorderSettings = [
    AVMediaTypeAudio: [
        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
        AVSampleRateKey: 0,
        AVNumberOfChannelsKey: 0,
    ],
    AVMediaTypeVideo: [
        AVVideoCodecKey: AVVideoCodecH264,
        AVVideoHeightKey: 0,
        AVVideoWidthKey: 0,
    ],
]
```
### Authentication
```swift
var rtmpConnection:RTMPConnection = RTMPConnection()
rtmpConnection.connect("rtmp://username:password@localhost/appName/instanceName")
```

### Screen Capture
```swift
// iOS
rtmpStream.attach(screen: ScreenCaptureSession())
// macOS
rtmpStream.attach(screen: AVCaptureScreenInput(displayID: CGMainDisplayID()))
```

## HTTP Usage
HTTP Live Streaming (HLS). Your iPhone/Mac become a IP Camera. Basic snipet. You can see http://ip.address:8080/hello/playlist.m3u8 
```swift
var httpStream:HTTPStream = HTTPStream()
httpStream.attach(camera: AVMixer.deviceWithPosition(.Back))
httpStream.attach(audio: AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio))
httpStream.publish("hello")

var lfView:LFView = LFView(frame: view.bounds)
lfView.attach(stream: httpStream)

var httpService:HTTPService = HTTPService(domain: "", type: "_http._tcp", name: "lf", port: 8080)
httpService.startRunning()
httpService.add(httpStream: httpStream)

// add ViewController#view
view.addSubview(lfView)
```

## License
New BSD

## Enviroment
|lf|iOS|OSX|Swift|CocoaPods|Carthage|
|:----:|:----:|:----:|:----:|:----:|:----:|
|0.5|8.0|10.11|3.0|1.1.0|◯|
|0.4|8.0|10.11|2.3|1.0.0|◯|
|0.3|8.0|10.11|2.3|1.0.0|-|
|0.2|8.0|-|2.3|0.39.0|-|

## Reference
* Adobe’s Real Time Messaging Protocol
 * http://www.adobe.com/content/dam/Adobe/en/devnet/rtmp/pdf/rtmp_specification_1.0.pdf
* Action Message Format -- AMF 0
 * http://wwwimages.adobe.com/content/dam/Adobe/en/devnet/amf/pdf/amf0-file-format-specification.pdf
* Action Message Format -- AMF 3 
 * http://wwwimages.adobe.com/www.adobe.com/content/dam/Adobe/en/devnet/amf/pdf/amf-file-format-spec.pdf
* Video File Format Specification Version 10
 * https://www.adobe.com/content/dam/Adobe/en/devnet/flv/pdfs/video_file_format_spec_v10.pdf
* Adobe Flash Video File Format Specification Version 10.1
 * http://download.macromedia.com/f4v/video_file_format_spec_v10_1.pdf

