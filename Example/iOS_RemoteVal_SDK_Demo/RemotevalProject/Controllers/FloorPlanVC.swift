//
//  ViewController.swift
//  RemotevalProject
//
//  Created by Akash Sheth on 15/11/22.
//

import UIKit
import RemotevalSDK

class FloorPlanVC: UIViewController {
    
    var sasToken = ""
    var containerName = ""
    var fullContainerPath = ""
    
    var jobOrderId = ""
    
    var floorIndex = ""
    var floorName = ""
    var wallThickness = ""
    var selectedScanOption : getMeasurementOption?
    
    
    @IBOutlet weak var txtFloor: UITextField!
    @IBOutlet weak var txtWall: UITextField!

    @IBOutlet weak var txtScanOption: UITextField!
    
    
    var floorSelectionPickerView = UIPickerView()
    var wallThicknessPickerView = UIPickerView()
    var floorTechniquePickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wallThicknessPickerView.delegate = self
        wallThicknessPickerView.dataSource = self
        floorSelectionPickerView.delegate = self
        floorSelectionPickerView.dataSource = self
        floorTechniquePickerView.dataSource = self
        floorTechniquePickerView.delegate = self
        
        txtWall.inputView = wallThicknessPickerView
        txtFloor.inputView = floorSelectionPickerView
        txtScanOption.inputView = floorTechniquePickerView
        addToolbarAtPickerView()
        setInitData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        AppDelegate.rotateToPotraitDevice()
    }
    
    func setInitData() {
        wallThicknessPickerView.selectRow(0, inComponent:0, animated:true)
        floorSelectionPickerView.selectRow(0, inComponent:0, animated:true)
        //floorTechniquePickerView.selectRow(0, inComponent: 0, animated: true)
        floorName = RVConfigClass.shared.arrFloorNames[0].values.first ?? ""
        floorIndex = RVConfigClass.shared.arrFloorNames[0].keys.first ?? ""
        wallThickness = RVConfigClass.shared.arrWallTickness[0]
        selectedScanOption = RVConfigClass.shared.arrFloorScanOptions[0]
        txtScanOption.text = selectedScanOption?.stringSet()
        txtWall.text = wallThickness
        txtFloor.text = floorName
    }
    
    func addToolbarAtPickerView() {
        let toolBar1 = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        toolBar1.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar1.barStyle = UIBarStyle.default
        toolBar1.backgroundColor = UIColor.lightGray
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let okBarBtn1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(donePress))
        let btnDone = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(donePress))
        toolBar1.setItems([btnDone,flexSpace,flexSpace,flexSpace,okBarBtn1], animated: true)
        txtWall.inputAccessoryView = toolBar1
        txtFloor.inputAccessoryView = toolBar1
        txtScanOption.inputAccessoryView = toolBar1
    }
    
    @objc func donePress(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }
    
    func isValidate() -> Bool {
        
        guard txtFloor.text != ""  else {
            Alert.shared.show(message: "Please select floor")
            return false
        }
        
        guard txtWall.text != ""  else {
            Alert.shared.show(message: "Please select wallthickness")
            return false
        }
        
        return true
    }
    
    func openVideoScaningScreen() {
        let objVal = RvVideoBaseScan()
        //This call back call after scannig complete
        
        objVal.callBackAfterZipCreate = { (filePath, fileName, tplAutomaticFloorPlan) in
            
            self.navigationController?.popViewController(animated: true)
            
            guard let filePath = filePath , let fileName = fileName else {
                return
            }
            
            self.txtWall.text = ""
            self.txtFloor.text = ""
            
            //This function call for get storage detail
            RVConfigClass.shared.getUploadStorageDetail(jobOrderId: self.jobOrderId) { storageInfo in
                
                
                //This function call for upload scan to server
                RVConfigClass.shared.uploadScan(filePath: filePath, fileName: fileName, storageInfo: storageInfo) {
                    Alert.shared.dismissedAllAlert()
                    
                    //This function call for upload floor scan details 
                    self.floorScanUpload(fileName: "\(fileName).zip")
                } uploadComplition: { progress in
                    let valueForProgress = Int(progress * 100)
                    Alert.shared.showProgressWith("Uploading files : \(valueForProgress)%", message: "Please do not exit the application and don't go in the background." , updateProgress: progress, buttons: ["Cancel"])
                } failureHandler: { error in
                    //HandleError Here
                    Alert.shared.show(message: error.localizedDescription)
                }
                
            } failureHandler: { error in
                //handleError here
                Alert.shared.show(message: error.reason)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            objVal.jobOrderId = self.jobOrderId
            objVal.floorName = self.floorName
            objVal.selectedMeasurementOption = self.selectedScanOption!
            objVal.buttonBackgroundColor = UIColor(named: GLOBAL_VALUES.selectedBackGroundColor) ?? UIColor()
            objVal.buttonTextColor = UIColor(named: GLOBAL_VALUES.selectedTextColor) ?? UIColor()
            if self.selectedScanOption != .objectToPLY {
                AppDelegate.rotateToLandscapeRightDevice()
            }
            self.navigationController?.setNeedsUpdateOfSupportedInterfaceOrientations()
            self.navigationController?.pushViewController(objVal, animated: true)
        }
    }
    
    @IBAction func btnStartScanningAction(_ sender: UIButton) {
        
        //if isValidate() {
        self.openVideoScaningScreen()
//        } else {
//            // Validation message
//        }
        
        
    }
    
    
    
    func floorScanUpload(fileName: String) {
        
        
        RVConfigClass.shared.uploadFloorScanDetail(jobOrderId: self.jobOrderId, floorIndex: Int(floorIndex) ?? 0, wallThickness: wallThickness, fileName: fileName, scanOption: selectedScanOption!) {
            // success
            debugPrint("FloorScan Upload SuccessFully")
            Alert.shared.show(title: "FloorScan Upload SuccessFully", message: "Do you want to Scan Another Floor?", buttons: ["Cancel" , "Yes"]) { strButton in
                if strButton == "Yes" {
                    if self.isValidate() {
                        self.openVideoScaningScreen()
                    }
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } failureHandler: { error in
            //handleError Here
            Alert.shared.show(message: error.localizedDescription)
        }

    }
    


}

//MARK:- UIpicker Delegate Methods
extension FloorPlanVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // number of session
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == wallThicknessPickerView {
            return RVConfigClass.shared.arrWallTickness.count
        } else if pickerView == floorSelectionPickerView {
            return RVConfigClass.shared.arrFloorNames.count
        } else if pickerView == floorTechniquePickerView {
            return RVConfigClass.shared.arrFloorScanOptions.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == wallThicknessPickerView {
            return RVConfigClass.shared.arrWallTickness[row]
        } else if pickerView == floorSelectionPickerView {
            return RVConfigClass.shared.arrFloorNames[row].values.first ?? ""
        } else if pickerView == floorTechniquePickerView {
            return RVConfigClass.shared.arrFloorScanOptions[row].stringSet()
        } else {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == wallThicknessPickerView {
            wallThickness = RVConfigClass.shared.arrWallTickness[row]
            txtWall.text = wallThickness
        } else if pickerView == floorSelectionPickerView {
            floorName = RVConfigClass.shared.arrFloorNames[row].values.first ?? ""
            floorIndex = RVConfigClass.shared.arrFloorNames[row].keys.first ?? ""
            txtFloor.text = floorName
        } else if pickerView == floorTechniquePickerView {
            selectedScanOption = RVConfigClass.shared.arrFloorScanOptions[row]
            txtScanOption.text = selectedScanOption?.stringSet()
        }
    }
    
    
}
