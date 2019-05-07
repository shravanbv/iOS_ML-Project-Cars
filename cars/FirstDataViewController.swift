//
//  FirstDataViewController.swift
//  cars
//
//  Created by Shravan on 12/11/19.
//  Copyright © 2019 Shravan. All rights reserved.
//

import UIKit

class FirstDataViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    
    var mode = "buy"
    @IBOutlet weak var brandModelPickerView: UIPickerView!
    @IBOutlet weak var gearBoxPickerView: UIPickerView!
    @IBOutlet weak var fuelTypePickerView: UIPickerView!
    @IBOutlet weak var vehicleTypePickerView: UIPickerView!
    
    var brandAndModels:Dictionary<String,Array<String>>?
    var brands:Array<String>?
    var models:Array<String>?
    var gearBox = ["Automatic","Manual"]
    var fuelType = ["other","benzin","cng","deisel","electric","hybrid","lpg"]
    var vehicleType = ["other","bus","cabrio","coupe","kleinwagen","kombi","limousine","suv"]
    
    var selectedBrand:String?
    var selectedModel:String?
    var selectedGearBox:String?
    var selectedFuelType:String?
    var selectedVehicleType:String?
    var carbrands: Dictionary<String,Int>?
    var carmodels: Dictionary<String,Int>?
    
    var brandIndex:Int = 0
    var modelIndex:Int = 0
    var gearboxIndex:Int = 0
    var fuelTypeIndex:Int = 0
    var vehicleTypeIndex:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            brandModelPickerView.delegate = self
            gearBoxPickerView.delegate = self
            fuelTypePickerView.delegate = self
            vehicleTypePickerView.delegate = self

        let data:Bundle = Bundle.main
        let carModelPlist:String? = data.path(forResource: "carmodel", ofType: "plist")
        if carModelPlist != nil {
            brandAndModels = (NSDictionary.init(contentsOfFile: carModelPlist!) as! Dictionary)
            brands = brandAndModels?.keys.sorted()
            selectedBrand = brands![0]
            models = brandAndModels![selectedBrand!]!
        }
        
       
        
       let brandPlist:String? = data.path(forResource: "brand", ofType: "plist")
        if brandPlist != nil {
            carbrands = (NSDictionary.init(contentsOfFile: brandPlist!) as! Dictionary)
        }
  
        let modelPlist:String? = data.path(forResource: "model", ofType: "plist")
        if  modelPlist != nil {
            carmodels = (NSDictionary.init(contentsOfFile: modelPlist!) as! Dictionary)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == brandModelPickerView {
            return 2
        }
        else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == brandModelPickerView {
            guard (brands != nil) &&  models != nil else { return 0 }
            switch component {
            case 0:
                return brands!.count
            case 1:
                return models!.count
            default:
                return 0
            }
        }
    
        else if pickerView == gearBoxPickerView {
            return gearBox.count
        }
        else if pickerView == fuelTypePickerView {
            return fuelType.count
        }
        else if pickerView == vehicleTypePickerView {
            return vehicleType.count
        }
        
        return 0
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
       if pickerView == brandModelPickerView {
        guard (brands != nil) && models != nil else { return "None" }
        switch component {
        case 0:
            return brands![row]
        case 1:
            return models![row]
        default: return "None"
        }
       }
        
       else if pickerView == gearBoxPickerView {
        return gearBox[row]
       }
       else if pickerView == fuelTypePickerView {
        return fuelType[row]
       }
       else if pickerView == vehicleTypePickerView {
        return vehicleType[row]
        }
        
       return "None"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == brandModelPickerView {
        guard (brands != nil) && models != nil else { return }
        if component == 0 {
            selectedBrand = brands![row]
            brandIndex = row;
            models = brandAndModels![selectedBrand!]
            pickerView.reloadComponent(1)
           }
        else if component == 1  {
            selectedModel = models![row]
            modelIndex = carmodels![selectedModel!]!
          }
            
        }
        else if pickerView == gearBoxPickerView {
            gearboxIndex = row
            selectedGearBox = gearBox[row]
        }
        else if pickerView == fuelTypePickerView {
            fuelTypeIndex = row
            selectedFuelType = fuelType[row]
        }
        else if pickerView == vehicleTypePickerView {
            vehicleTypeIndex = row
            selectedVehicleType = vehicleType[row]
        }
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SecondDataViewController {
            destination.mode = self.mode
            destination.brandIndex = self.brandIndex
            destination.modelIndex = self.modelIndex
            destination.gearboxIndex = self.gearboxIndex
            destination.fuelTypeIndex = self.fuelTypeIndex
            destination.vehicleTypeIndex = self.vehicleTypeIndex
        }
    }
    

    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
