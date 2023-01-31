# iOSRemoteValScanner
# RemoteVal Scanning SDK

## Table of Contents

* [RemoteVal Demo](#remoteval-demo)
* [Video-based scan library module](#video-based-scan-library-module)
* [Implementation](#implementation)
    * [Insallation](#installation)
    * [Setting up](#setting-up)
    * [Device Orientation Setup](#device-orientation-setup)
* [RemoteVal SDK Features](#remoteval-sdk-features)
    * [Adaptive Lighting](#adaptive-lighting)
    * [Storage Warning](#storage-warning)
    * [Feedback Gathering](#feedback-gathering)
* [Permissions](#permissions)
* [Configuration](#configuration)
* [Uploading Part](#uploading-part)
* [Custom Localization](#custom-localization)



## RemoteVal Demo

This project provides an example implementation and use of the RemoteVal Video-based scanning library module. From this project, you can get a basic idea of how to implement the scanning with RemoteVal capture in your app.

## Video-based scan library module

RemoteVal Video-based scanning library module provides a scanning `View Controller` which can be used to
scan a floor plan with an iOS device. The scanning `View Controller` saves scan files into a zip file,
which your app can upload to the RemoteVal back-end for processing. RemoteVal SDK handles corner
cases like fast scanning, Too near to the wall, and ceiling scanning to guide users in proper scanning

## Implementation
This implementation was made with Xcode.

### Installation

The preferred (and easiest) way to install the Remoteval SDK is with cocoa pods. Add the following to your `Podfile`:

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

For a better user experience add these two methods in your Appdelegate.swift file

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

RemoteVal SDK features the Adaptive Lighting technique. During the scan, if the lighting is too dark automatically light up the torch/flashlight of the phone to illuminate the surroundings. The brightness level of the torch depends on the surrounding lighting conditions less light, more torch, and the other way around.

### Storage Warning

RemoteVal SDK notifies the user if the device is running out of storage space.

### Feedback Gathering

RemoteVal SDK keeps a separate log of warnings during the scan. This will be used in the future for improving the scanning technique.

## Permissions

RemoteVal SDK uses the device camera to capture the surroundings so you need to add the "Privacy - Camera Usage Description" to your project's Info.plist if you already haven't done so. The camera permission is required for the SDK, it cannot function without it.

```xml

   <key>NSCameraUsageDescription</key>
	<string>uses your camera to allow the user to scan the property</string>
   
```


## Configuration

1. You need to set `Development Environment and Provide Your Client Key` using this function and put this in viewDidLoad()

```swift

RVConfigClass.shared.configSDK(environment: RemoteValEnvironmet.dev, clientKey: Constants.clientKey) {
    //success
} failureHandler: { rvError in
    //onFailure
}

```

- here you have to pass Environment Development from the `RemoteValEnvironment` type
- the second you have to pass `Your_Client_key`

2. The way to use `RvVideoBaseScan` as a `UIViewController`

```swift
import RemotevalSDK
...
let videoBaseScanVC = RvVideoBaseScan()
videoBaseScanVC.jobOrderId = self.jobOrderId
videoBaseScanVC.floorName = self.floorName
self.navigationController?.pushViewController(videoBaseScanVC, animated: true)
```
Note: Here you need to provide `jobOrderId` and `floorName` to VideoBaseScan class.
jobOrderId and floorName require because of creating a Zip file and you get fileName.


## Uploading Part

To take input from users regarding the job order you've to create UIViewController. This will be the launcher View controller for your previous push controller.

## For uploading a video follow these steps.

1. Generate Job Order

When you call `generateJobOrder()` function you get jobOrderId.
`jobOrderId` use to upload capture video and create floor scan

```swift
//Create OrderInformation by filling below values
let param = OrderInfoRequest(ownerEmail: "", 
                             ownerName: "", 
                             ownerPhone: "", 
                             propertyAddress: "", 
                             propertyCity: "", 
                             propertyCountry: RVCountry, 
                             propertyState: RVState, 
                             latitude: "", 
                             lontitude: "", 
                             propertyType: PropertyType.RESIDENTIAL OR PropertyType.COMMERCIAL, 
                             propertyZip: "" )
        
        
RVConfigClass.shared.generateJobOrder(orderInfoRequest: param) { id in
   //id equals to jobOrderID
}
```

- Here you have to pass countryModel and StateModel in `propertyCountry` and `propertyState` parameters.
- The way to use RVCountry and RVState 

```swift

//For Country
RVConfigClass.shared.allCountries

//For State
RVConfigClass.shared.allStates

```

- In Property you have to pass `PropertyType` type pf value , you can access it by using `PropertyType` itself.


2. Zip Creation and get the file name and file path 

After Scanning completion, you get `filePath` and `fileName` with the use of this callback.
fileName and filePath are required to upload files to the server.

```swift

videoBaseScanVC.callBackAfterZipCreate = { (filePath, fileName) in
}

```


3. After Getting jobOrderId you have to call the function to get the upload path.

To get the path you have to pass jobOrderId in the param and call this function 

```swift 

RVConfigClass.shared.getUploadStorageDetail(jobOrderId: job_Order_Id) { storageInfo in
   //onSuccess
} failureHandler: { rvError in
   //onFailure
}

```
 

4. Upload Scanned file: Once you get filepath call this function to upload the file to the server

- You have to pass filePath and fileName here, which you get from the callback of videoBaseScan class `callBackAfterZipCreate`.
- You have to pass storageInfo, you get from on success of `getUploadStorageDetail` function.

```swift

RVConfigClass.shared.uploadScan(filePath: filePath, fileName: fileName, storageInfo: storageInfo) {
   //success
} uploadComplition: { progress in
   //getProgress
} failure: { error in
   //errorhandling
}

```


5. Create Floor Scan: After successfully uploading the Scanned Zip file you've to create a floor scan using

Here you have to pass jobOrderId which you get from the generateJobOrder function.
The second param passes floorIndex as an Integer datatype.
The param pass wallThickness and last is fileName.

Note:- `floorIndex` and `wallThickness` will get an array from SDK and you can get a reference from the demo on how to take data from the user.


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


The Remoteval SDK is localizable to any language. At the moment we support only English translations but if your app has support for multiple languages you can easily also translate all texts in the SDK. If you want to use a different tone in the texts or something you can always define your own.

The following is an excerpt from the SDK’s Localizable.strings; just define your own texts with the following. See the Localizable.strings file in this project. By overriding the keys you can change the text as you, please.
