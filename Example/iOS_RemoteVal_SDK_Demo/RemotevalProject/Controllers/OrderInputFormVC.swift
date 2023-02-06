//
//  OrderInputFormVC.swift
//  RemotevalProject
//
//  Created by Akash Sheth on 07/12/22.
//

import UIKit
import RemotevalSDK
//import ObjectMapper

class OrderInputFormVC: UIViewController {
    
    @IBOutlet weak var txtOwnerName: UITextField!
    @IBOutlet weak var txtOwnerEmail: UITextField!
    @IBOutlet weak var txtOwnerPhone: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtPostalCode: UITextField!
    @IBOutlet weak var txtThemeColor: UITextField!
    @IBOutlet weak var txtTextColor: UITextField!
    
    @IBOutlet weak var txtViewAddress: UITextView!
    
    @IBOutlet weak var btnCountinue: UIButton!
    
    
    var backgroundColorPickerView = UIPickerView()
    var textColorPickerView = UIPickerView()
    var countryPickerView = UIPickerView()
    var statesPickerView = UIPickerView()
    
    var aryBackgroundColorNames = ["Endeavour" ,"Violet" ,"RegalBlue" ,"Red", "Wine"]
    var aryTextColorNames = ["White" ,"Black", "Yellow", "Gray", "Brown"]
    
    var selectedCountry: RVCountry?
    var selectedState: RVState?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //RVConfigClass.shared.environment = RemoteValEnvironmet.dev
        forTestOnly()
        backgroundColorPickerView.delegate = self
        backgroundColorPickerView.dataSource = self
        textColorPickerView.delegate = self
        textColorPickerView.dataSource = self
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        statesPickerView.delegate = self
        statesPickerView.dataSource = self
        
        txtThemeColor.inputView = backgroundColorPickerView
        txtTextColor.inputView = textColorPickerView
        txtCountry.inputView = countryPickerView
        txtState.inputView = statesPickerView
        
        setInitData()
        
        RVConfigClass.shared.configSDK(environment: RemoteValEnvironmet.dev, clientKey: Constants.clientKey) {
            //success
        } failureHandler: { rvError in
            //onFailure
            Alert.shared.show(message: rvError.reason)
        }
    }
    
    func forTestOnly() {
        countryPickerView.selectRow(0, inComponent:0, animated:true)
        statesPickerView.selectRow(0, inComponent: 0, animated: true)
        selectedCountry = RVConfigClass.shared.allCountries[0]
        selectedState = RVConfigClass.shared.allStates[0]
        
        txtOwnerEmail.text = "demo@remoteval.com"
        txtOwnerName.text = "Sdk iOS test"
        txtOwnerPhone.text = "33445342"
        txtViewAddress.text = "(256) 314-3925130 Cypress Ln"
        txtCity.text = "Newark"
        txtCountry.text = selectedCountry?.name ?? ""
        txtState.text = selectedState?.name ?? ""
        txtPostalCode.text = "08002"
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
        txtThemeColor.inputAccessoryView = toolBar1
        txtTextColor.inputAccessoryView = toolBar1
        txtCountry.inputAccessoryView = toolBar1
        txtState.inputAccessoryView = toolBar1
    }
    
    @objc func donePress(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }
    
    func setInitData() {
        backgroundColorPickerView.selectRow(0, inComponent:0, animated:true)
        textColorPickerView.selectRow(0, inComponent:0, animated:true)
        
        GLOBAL_VALUES.selectedBackGroundColor = aryBackgroundColorNames[0]
        GLOBAL_VALUES.selectedTextColor = aryTextColorNames[0]
        
        btnCountinue.backgroundColor = UIColor(named: GLOBAL_VALUES.selectedBackGroundColor)
        btnCountinue.setTitleColor(UIColor(named: GLOBAL_VALUES.selectedTextColor), for: .normal)
        
        txtThemeColor.text = GLOBAL_VALUES.selectedBackGroundColor
        txtTextColor.text = GLOBAL_VALUES.selectedTextColor
    }
    
    @IBAction func btnNextAction(_ sender: UIButton) {
        
        self.generateJobOrderApiCall()
        
//        RVConfigClass.shared.testSetUpFunc(environment: RemoteValEnvironmet.dev, clientKey: Constants.clientKey)
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FloorPlanVC") as! FloorPlanVC
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //MARK:- Api Call Functions
    
    func generateJobOrderApiCall() {
        guard let selectedCountry = selectedCountry else { return }
        guard let selectedState = selectedState else { return }

        let requestObj = OrderInfoRequest(ownerEmail: txtOwnerEmail.text ?? "demo@remoteval.com", ownerName: txtOwnerName.text ?? "Sdk iOS test", ownerPhone: txtOwnerPhone.text ?? "33445342", propertyAddress: txtViewAddress.text ?? "(256) 314-3925130 Cypress Ln", propertyCity: txtCity.text ?? "Newark", propertyCountry: selectedCountry, propertyState: selectedState, latitude: "", longitude: "", propertyType: PropertyType.RESIDENTIAL, propertyZip: txtPostalCode.text ?? "08002")
        
        RVConfigClass.shared.startLoadingDelegate(BaseModel())
        
        RVConfigClass.shared.generateJobOrder(orderInfoRequest: requestObj) { resJobOrderId in
            RVConfigClass.shared.stopLoadingDelegate(BaseModel())
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FloorPlanVC") as! FloorPlanVC
                vc.jobOrderId = resJobOrderId
            self.navigationController?.pushViewController(vc, animated: true)

        } failureHandler: { rvError in
            RVConfigClass.shared.stopLoadingDelegate(BaseModel())
            //onFailure
            Alert.shared.show(message: rvError.reason)
        }
    }
}


//MARK:- UIpicker Delegate Methods
extension OrderInputFormVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // number of session
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case backgroundColorPickerView:
            return aryBackgroundColorNames.count
        case textColorPickerView:
            return aryTextColorNames.count
        case countryPickerView:
            return RVConfigClass.shared.allCountries.count
        case statesPickerView:
            return RVConfigClass.shared.allStates.count
        default:
            return 0
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView {
        case backgroundColorPickerView:
            return aryBackgroundColorNames[row]
        case textColorPickerView:
            return aryTextColorNames[row]
        case countryPickerView:
            return RVConfigClass.shared.allCountries[row].name
        case statesPickerView:
            return RVConfigClass.shared.allStates[row].name
        default:
            return ""
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == backgroundColorPickerView {
            GLOBAL_VALUES.selectedBackGroundColor = aryBackgroundColorNames[row]
        } else if pickerView == textColorPickerView {
            GLOBAL_VALUES.selectedTextColor = aryTextColorNames[row]
        } else if pickerView == countryPickerView {
            txtCountry.text = RVConfigClass.shared.allCountries[row].name
            selectedCountry = RVConfigClass.shared.allCountries[row]
        } else if pickerView == statesPickerView {
            txtState.text = RVConfigClass.shared.allStates[row].name
            selectedState = RVConfigClass.shared.allStates[row]
        }
        
        
        
        txtThemeColor.text = GLOBAL_VALUES.selectedBackGroundColor
        txtTextColor.text = GLOBAL_VALUES.selectedTextColor
        
        btnCountinue.backgroundColor = UIColor(named: GLOBAL_VALUES.selectedBackGroundColor)
        btnCountinue.setTitleColor(UIColor(named: GLOBAL_VALUES.selectedTextColor), for: .normal)
    }
    
    
}
