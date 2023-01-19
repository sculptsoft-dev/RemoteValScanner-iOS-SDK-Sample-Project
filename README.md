# iOSRemotValScanner
# RemoteVal Scanning SDK

## Table of Contents

* [Remoteval Demo](#remoteval-demo)
* [Video based scan library module](#video-based-scan-library-module)
* [Implementation](#implementation)
    * [Insallation](#installation)
    * [Setting up](#setting-up)
    * [Device Orientation Setup](#device-orientation-setup)
* [Remoteval SDK Features](#remoteval-sdk-features)
    * [Adaptive Lighting](#adaptive-lighting)
    * [Storage Warning](#storage-warning)
    * [Feedback Gathering](#feedback-gathering)
* [Permissions](#permissions)
* [Configuration](#configuration)
* [Uploading Part](#uploading-part)
* [Custom Localization](#custom-localization)



## Remoteval Demo

This project provides an example implementation and use of the RemoteVal Video based scanning library module. From this project you can get the basic idea of how to implement the scanning with RemoteVal capture to your app.

## Video based scan library module

RemoteVal Video based scanning library module provides a scanning `View Controller` which can be used to
scan a floor plan with an iOS device. The scanning `View Controller` saves scan files into a zip file,
which your app can upload to the RemoteVal back-end for processing. RemoteVal SDK handles corner
cases like fast scanning, Too near to wall, ceiling scanning to guide user for proper scanning

## Implementation
This implementation was made with xcode.

### Installation

The preferred (and easiest) way to install the Remoteval SDK is with cocoapods. Add the following to your `Podfile`:

```swift
```

### Setting up

You can access functions and variables using RVConfigClass.shared 

### Device Orientation Setup
- The RemotevalSDK uses the landscape-right orientation (instead of locking the orientation to portrait). This means that your app needs to support (at least) landscape-right orientation.

You have to set orientation in `Appdelegate.swift` file 
```swift

var orientationLock = UIInterfaceOrientationMask.portrait
......
func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return orientationLock
}

```

For better user experience add these two methods in your Appdelegate.swift file

```swift 
    static func rotateToLandscapeRightDevice() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = .landscapeRight
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
            UIView.setAnimationsEnabled(false)
            UINavigationController.attemptRotationToDeviceOrientation()
        }
    }
    
    static func rotateToPotraitDevice() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = .portrait
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            UIView.setAnimationsEnabled(false)
            UINavigationController.attemptRotationToDeviceOrientation()
        }
    }

```

## Remoteval SDK Features

### Adaptive Lighting

Remoteval SDK features the Adaptive Lighting technique. During the scan if the lighting is too dark automatically lights up the torch/flashlight of the phone to illuminate the surroundings. The brightness level of the torch depends on the surrounding lightgning conditions. Less light, more torch and the other way around.

### Storage Warning

Remoteval SDK notifies the user if the device is running out of storage space. This feature is toggled with the .storageWarnings scanning option.

### Feedback Gathering

Remoteval SDK keeps a separate log of warnings during the scan. This will be used in the future for improving the scanning technique.

## Permissions

Remoteval SDK uses the device camera to capture the surroundings so you need to add the "Privacy - Camera Usage Description" to your projects Info.plist if you already haven't done so. The camera permission is required for the SDK, it cannot function without it.


## Configuration

1. You need to set `Developement Envirenemt and Provide Your Client Key` using this function put this in viewDidLoad()

```swift

RVConfigClass.shared.configSDK(environment: RemoteValEnvironmet.dev, clientKey: Constants.clientKey) {
    //success
} failureHandler: { rvError in
    //onFailure
}

```

- here you have to pass Enviornment Development from `RemoteValEnvironment` type
- second you have to pass `Your_Client_key`

2. The way to use `VideoBaseScan` as a `UIViewController`

```swift
import RemotevalSDK
...
let cntrlVideoBaseScan = VideoBaseScan()
cntrlVideoBaseScan.jobOrderId = self.jobOrderId
cntrlVideoBaseScan.floorName = self.floorName
self.navigationController?.pushViewController(cntrlVideoBaseScan, animated: true)
```
Note: Here you need to provide `jobOrderId` and `floorName` to VideoBaseScan class.
jobOrderId and floorName require because of create Zip file and you get fileName.


## Uploading Part

To take input from user regarding job order you've to create UIViewController. This will be launcher View controller for your previously push controller.

## For uploading video follow these steps.

1. Generate Job Order

When you call `generateJobOrder()` function you get jobOrderId.
`jobOrderId` use for upload capture video and create floor scan

```swift
//Create OrderInformation by filling below values
let param = OrderInfoRequest(jobOrderSource: "sdk", 
                             ownerEmail: "", 
                             ownerName: "", 
                             ownerPhone: "", 
                             propertyAddress: "", 
                             propertyCity: "", 
                             propertyCountry: CountryModel, 
                             propertyState: StateModel, 
                             latitude: "", 
                             lontitude: "", 
                             propertyType: PropertyType.RESIDENTIAL OR PropertyType.COMMERCIAL, 
                             propertyZip: txtPostalCode.text ?? "08002" )
        
        
    RVConfigClass.shared.generateJobOrder(orderInfoRequest: param) { id in
        //id equals to jobOrderID
    }
```

- Here you have to pass countryModel and StateModel in `propertyCountry` and `propertyState` parameter.

- The way to use CountryModel and StateModel 

```swift

//For Country
RVConfigClass.shared.allCountries

//For State
RVConfigClass.shared.allStates

```

- In Property you have to pass `PropertyType` type pf value , you can access by using `PropertyType` it self.


2. Zip Creation and get file name and file path 

After Scaning compltion you get `filePath` and `fileName` with the use of this call back.
fileName and filePath is require for upload file in server.

```swift

let videoBaseScanVC = VideoBaseScan()

videoBaseScanVC.callBackAfterZipCreate = { (filePath, fileName) in
}

```


3. After Getting jobOrderId you have to call function for get upload path.

For get path you have to pass jobOrderId in param and call this function 

```swift 
    RVConfigClass.shared.getUploadStorage(jobOrderId: job_Order_Id)
```
 

4. Upload Scanned file : Once you get filepath call this function for upload file to server

You have to pass filePath and fileName here, which you get from previous call back.

```swift
    RVConfigClass.shared.uploadScan(filePath: filePath, fileName: fileName) {
        //success
    } uploadComplition: { progress in
        //getProgress
    } failure: { error in
        //errorhandling
    }
```


5. Create Floor Scan : After successfully upload Scanned Zip file you've to create floor scan using

Here you have to pass jobOrderId which you get from generateJobOrder function.
Second param pass floorIndex as a Integer datatype.
Thired param pass wallThickness and last is fileName.

Note:- `floorIndex` and `wallThickness` will get array from SDK and you can get reference from demo how to take data from user.


```swift

RVConfigClass.shared.uploadFloorScanDetail(jobOrderId: jobOrderId, 
                                            floorIndex: Int(floorIndex) ?? 0, 
                                            wallThickness: wallThickness, 
                                            fileName: fileName) {
            // success
            debugPrint("FloorScan Upload SuccessFully")
        } failureHandler: { error in
            //handleError Here
        }
```

## Custom Localization


The Remoteval SDK is localizable to any language. At the moment we support only English translations but if your app has support for multiple languages you can easily also translate all texts in the SDK as well. If you want to use a different tone in the texts or something you can always define your own.

The following is an excerpt from the SDK’s Localizable.strings; just define your own texts with the following. See the Localizable.strings file in this project. By overriding the keys you can change the text as you please.
