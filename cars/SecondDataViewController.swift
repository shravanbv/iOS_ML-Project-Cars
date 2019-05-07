//
//  SecondPartViewController.swift
//  cars
//
//  Created by Shravan on 12/11/19.
//  Copyright © 2019 Shravan. All rights reserved.
//

import UIKit
import CoreML

class SecondDataViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
   
    
    var mode = "buy"
    @IBOutlet weak var enginePowerTextFeild: UITextField!
    @IBOutlet weak var kilometersTextField: UITextField!
    @IBOutlet weak var registeredYearPickerView: UIPickerView!
    @IBOutlet weak var damagedPickerView: UIPickerView!
    @IBOutlet weak var sellingYearPickerView: UIPickerView!
    @IBOutlet weak var averageKmYearPickerView: UIPickerView!
    @IBOutlet weak var enginePowerErrorLabel: UILabel!
    @IBOutlet weak var kilometerErrorLabel: UILabel!
    
    @IBOutlet weak var sellingYearLabel: UILabel!
    @IBOutlet weak var averagekmLabel: UILabel!
    var brandIndex:Int?
    var modelIndex:Int?
    var gearboxIndex:Int?
    var fuelTypeIndex:Int?
    var vehicleTypeIndex:Int?
    var isDamaged:Int = 0
    var registerationYear:Int = 2017
    var sellYear:Int = 2017
    var averageKm:Double = 1000
    
    let model = usedcars()

   
    var registeredYear = [Int]()
    var damaged = ["yes","no"]
    var sellingYear = [Int]()
    var averageKmYear = [Int]()
    var pricesArray = [Price]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRegisteredYear()
        loadSellingYear()
        loadAverageKilomter()
        
        if mode == "buy" {
            sellingYearLabel.isHidden = true
            sellingYearPickerView.isHidden = true
            averagekmLabel.isHidden = true
            averageKmYearPickerView.isHidden = true
        }
        
        registeredYearPickerView.delegate = self
        damagedPickerView.delegate = self
        sellingYearPickerView.delegate = self
        averageKmYearPickerView.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func didTapView(gesture:UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    func loadRegisteredYear(){
        registeredYear.removeAll()
        for index in 1950...2017 {
            registeredYear.append(index)
        }
        registeredYear.reverse()
    }
    
    func loadSellingYear() {
        sellingYear.removeAll()
        for index in 2017...2045 {
            sellingYear.append(index)
        }
    }

    func loadAverageKilomter(){
        averageKmYear.removeAll()
        for index in stride(from: 1000, to: 25000, by: 1000) {
            averageKmYear.append(index)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerView {
        case registeredYearPickerView: return registeredYear.count
        case damagedPickerView: return damaged.count
        case sellingYearPickerView: return sellingYear.count
        case averageKmYearPickerView: return averageKmYear.count
        default: return 0
        }
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case registeredYearPickerView: return String(registeredYear[row])
        case damagedPickerView: return damaged[row]
        case sellingYearPickerView: return String(sellingYear[row])
        case averageKmYearPickerView: return String(averageKmYear[row])
        default: return "None"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        view.endEditing(true)
        if pickerView == registeredYearPickerView {
            registerationYear = Int(registeredYear[row])
        }
        else if pickerView == damagedPickerView {
            isDamaged = row
        }
        else if pickerView == sellingYearPickerView {
            sellYear = sellingYear[row]
        }
        else if pickerView == averageKmYearPickerView {
            averageKm = Double(averageKmYear[row])
        }
    }
    

    
    
    @IBAction func predictPrice(_ sender: Any) {
        
        validateEnginePower()
        validateKilomter()
        
        if ((enginePowerErrorLabel.isHidden) && (kilometerErrorLabel.isHidden))  {
            if mode == "buy" {
                self.predictUsedCarPrice()
            }
            if mode == "sell" {
                self.predictSellingPrice()
            }
        }
    }
    
    func predictUsedCarPrice(){
        guard let result = try? model.prediction(yearOfRegistration: Double(registerationYear), powerPS: Double(enginePowerTextFeild.text!)!, kilometer: Double(kilometersTextField.text!)!, gearbox: Double(gearboxIndex!), notRepairedDamage: Double(isDamaged), model: Double(modelIndex!), brand: Double(brandIndex!), fuelType: Double(fuelTypeIndex!), vehicleType: Double(vehicleTypeIndex!)) else {
            fatalError("Unexpected runtime error.")
        }
        
        showResult(result.price)
    }
    
    
    func predictSellingPrice(){
       pricesArray.removeAll()
      
        
        for index in 2017...sellYear{
            let year = 2017-(index-2017)
            var totalKm = index == 2017 ? averageKm + Double(kilometersTextField.text!)! : Double((index-2017)) * averageKm + Double(kilometersTextField.text!)!
            totalKm = totalKm > 150000 ? 150000 : totalKm
            guard let result = try? model.prediction(yearOfRegistration: Double(year), powerPS: Double(enginePowerTextFeild.text!)!, kilometer: totalKm, gearbox: Double(gearboxIndex!), notRepairedDamage: Double(isDamaged), model: Double(modelIndex!), brand: Double(brandIndex!), fuelType: Double(fuelTypeIndex!), vehicleType: Double(vehicleTypeIndex!)) else {
                fatalError("Unexpected runtime error.")
            }
            pricesArray.append(Price(year: String(index),price: "$"+String(format:"%.2f", result.price))!)
        }
        
        let viewController = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListViewController") as? ListViewController)!
        
         viewController.prices = self.pricesArray
        self.present(viewController, animated: false, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ListViewController {
            destination.prices = self.pricesArray
           }
        }
    
    func validateEnginePower(){
        let enginePower = enginePowerTextFeild.text!
        if  enginePower == "" {
            enginePowerErrorLabel.text = "Engine Power is required"
            enginePowerErrorLabel.isHidden = false
        }
            
        else if (Int(enginePower)! < 10 || Int(enginePower)! > 500) {
            enginePowerErrorLabel.text = "Enter Value between 10 and 500"
            enginePowerErrorLabel.isHidden = false
        }
        else {
            enginePowerErrorLabel.isHidden = true;
        }
    }
   
    func validateKilomter(){
        let kilometer = kilometersTextField.text!
        if  kilometer == "" {
            kilometerErrorLabel.text = "Kilometers vlaue is required"
            kilometerErrorLabel.isHidden = false
        }
            
        else if (Int(kilometer)! < 0 || Int(kilometer)! > 150000) {
            kilometerErrorLabel.text = "Enter Value between 0 and 1500000"
            kilometerErrorLabel.isHidden = false
        }
        else {
            kilometerErrorLabel.isHidden = true;
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func showResult(_ result:Double) {
        let alert = UIAlertView.init(
            title: "Result",
            message:"$"+String(format:"%.2f", result),
            delegate: self,
            cancelButtonTitle: "Thank You")
        alert.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        guard buttonIndex != alertView.cancelButtonIndex else {return }
    
    }
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    
    
}
