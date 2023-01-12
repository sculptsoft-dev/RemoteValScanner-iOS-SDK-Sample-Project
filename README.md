# iOSRemotValScanner# RemoteVal Scanning SDK

## Example Project

This project provides an example implementation and use of the RemoteVal Video based scanning
library module. From this project you can get the basic idea of how to implement the scanning and
scan playback with RemoteVal capture to your app.

## Video based scan library module

RemoteVal Video based scanning library module provides a scanning `View Controller` which can be used to
scan a floor plan with an iOS device. The scanning `View Controller` saves scan files into a zip file,
which your app can upload to the RemoteVal back-end for processing. RemoteVal SDK handles corner
cases like fast scanning, Too near to wall, ceiling scanning to guide user for proper scanning

## Installation

<!--The prefer way to install RemoteVal SDK is integrate framwork in your project Follow these steps -->
<!--1. Select Project target-->
<!--2. Select `General` tab-->
<!--3. Click on plush button under `Framworks,Libraries, and Embedded Content`-->

## Setting up

You can access all class functions and variables using RVConfigClass.shared 

#### Device Orientation Setup
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

### Configuration
1. You need to set `Developement Envirenemt and Provide Your Client Key` using this function put this in viewDidLoad()
```swift
RVConfigClass.shared.configSDK(view: self.view , environment: RemoteValEnvironmet.dev, clientKey: `Your_Client_key`)
```

- here you have to pass Enviornment Development from `RemoteValEnvironment` type
- second you have to pass `Your_Client_key`

2. The way to use `push VideoBaseScan` as a `UIViewController`

```swift
import RemotevalSDK
...
let cntrlVideoBaseScan = VideoBaseScan()
self.navigationController?.pushViewController(cntrlVideoBaseScan, animated: true)
```
Note: Here you need to provide `jobOrderId` and `floorName` to VideoBaseScan class.



## Uploading Part

To take input from user regarding job order you've to create UIViewController. This will be launcher View controller for your previously push controller.

## For uploading video follow these steps.

1. Get Token

You have to call `getTanentToken(clientKey: Your_Client_key)` with success and failure handler.

```swift
RVConfigClass.shared.getTanentToken(clientKey: String, successHandler: (() -> Void), failureHandler: ((RemotValSDKError) -> Void))
```


2. Generate Order

When you call `generateJobOrder()` function you get jobOrderId.

```swift
//Create OrderInformation by filling below values
let param = JobOrderRequest(JSON:[
            "jobOrderSource": "Sdk",
            "latitude": "",
            "longitude": "",
            "ownerEmail": "",
            "ownerName": "",
            "ownerPhone": "",
            "propertyAddress1": "",
            "propertyCity": "",
            "propertyCountry": "",
            "propertyState": "",
            "propertyType": "RECIDENTIAL",
            "propertyZip": ""
        ])
    RVConfigClass.shared.generateJobOrder(orderInfoRequest: param) { id in
        //id equals to jobOrderID
    }
```

3. After Getting jobOrderId you have to call function for get path for upload.

For get path you have to pass jobOrderId in param and call this function 

```swift 
    RVConfigClass.shared.getUploadVideoPath(jobOrderId: job_Order_Id )
```
 
onSuccess you can start scan with push VideoBaseController and assign jobOrderId and floorName of VideoBaseController 

4. Zip Creation

After Scaning compltion you get `filePath` and `fileName` with the use of this call back.

```swift

let videoBaseScanVC = VideoBaseScan()

videoBaseScanVC.callBackAfterZipCreate = { (filePath, fileName) in
}

```


5. Upload Scanned file : Once you get filepath call this function for upload file to server

```swift
    RVConfigClass.shared.uploadFileToServer(filePath: filePath, fileName: fileName) {
        //success
    } uploadComplition: { progress in
        //getProgress
    } failure: { error in
        //errorhandling
    }
```

6. Create Floor Scan : After successfully upload Scanned Zip file you've to create floor scan using

```swift

RVConfigClass.shared.floorScanStatusUpdate(jobOrderId: jobOrderId, 
                                            floorIndex: Int(floorIndex) ?? 0, 
                                            wallThickness: wallThickness, 
                                            fileName: fileName) {
            // success
            debugPrint("FloorScan Upload SuccessFully")
        } failureHandler: { error in
            //handleError Here
        }
```
