//
//  ViewController.swift
//  Convert It
//
//  Created by Mark on 3/11/18.
//  Copyright © 2018 Mark. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    struct Formula {
        
        var conversionString: String
        var formula: (Double) -> Double
        
        
    }
    
    @IBOutlet var userInput: UITextField!
    @IBOutlet var resultsLabel: UILabel!
    @IBOutlet var formulaPicker: UIPickerView!
    @IBOutlet var fromUnitsLabel: UILabel!
    @IBOutlet var decimalSegment: UISegmentedControl!
    @IBOutlet var signSegment: UISegmentedControl!
    
    let formulasArray = [Formula(conversionString: "miles to kilometers", formula: {$0 / 0.62137}),
                         Formula(conversionString: "kilometers to miles", formula: {$0 * 0.62137}),
                         Formula(conversionString: "yards to meters", formula: {$0 / 1.0936}),
                         Formula(conversionString: "feet to meters", formula: {$0 / 3.2808}),
                         Formula(conversionString: "meters to feet", formula: {$0 * 0.62137}),
                         Formula(conversionString: "meters to yards", formula: {$0 * 1.0936}),
                         Formula(conversionString: "inches to cm", formula: {$0 / 0.3937}),
                         Formula(conversionString: "fahrenheit to celsius", formula: {(($0 - 32) * (5/9))}),
                         Formula(conversionString: "celsius to fahrenheit", formula: {($0 * (9/5)) + 32}),
                         Formula(conversionString: "quarts to liters", formula: {$0 / 1.05669}),
                         Formula(conversionString: "liters to quarts", formula: {$0 * 1.05669}),
                         ]
 
   
    
    var fromUnits = ""
    var toUnits = ""
    var conversionString = ""
    
    
    // MARK:- class methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formulaPicker.dataSource = self
        formulaPicker.delegate = self
        conversionString = formulasArray[formulaPicker.selectedRow(inComponent: 0)].conversionString
        userInput.becomeFirstResponder()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    func calculateConversion() {
        if userInput.text != "" {
        guard let inputValue = Double(userInput.text!) else {
            createAlert(title: "Error", message: "User input is not a valid number.")
            return
        }
        
        var outputValue = formulasArray[formulaPicker
            .selectedRow(inComponent: 0)].formula(inputValue)
        
        
        
        let formatString = (decimalSegment.selectedSegmentIndex < decimalSegment.numberOfSegments - 1 ? "%.\(decimalSegment.selectedSegmentIndex+1)f" : "%f")
        let outputString = String(format: formatString, outputValue)
        resultsLabel.text = "\(inputValue) \(fromUnits) = \(outputString) \(toUnits)"
        
        }
    }
    
    // MARK: IBActions
    @IBAction func userInputChanged(_ sender: Any) {
        
        resultsLabel.text = ""
        if userInput.text?.first == "-" {
            signSegment.selectedSegmentIndex = 1
        } else {
            signSegment.selectedSegmentIndex = 0
        }
        
    }
    
    
    @IBAction func convertButtonDidPressed(_ sender: Any) {
        
            calculateConversion()
        
    }
    
    @IBAction func decimalSelected(_ sender: Any) {
        
        calculateConversion()
        
    }
    
    @IBAction func signSegmentSelected(_ sender: Any) {
        
        if signSegment.selectedSegmentIndex == 0 {
            userInput.text = userInput.text?.replacingOccurrences(of: "-", with: "")
        } else {
            userInput.text = "-" + userInput.text!
        }
        
        if userInput.text != "-" {
            calculateConversion()
            
        }
        
    }
    
    func createAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            alert.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
}


// MARK: PickerView Extensions
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return formulasArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return formulasArray[row].conversionString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        conversionString = formulasArray[row].conversionString
        
        if conversionString.contains("celsius".lowercased()) {
            
            signSegment.isHidden = false
            userInput.text = userInput.text?.replacingOccurrences(of: "-", with: "")
            signSegment.selectedSegmentIndex = 0
            
        } else {
            signSegment.isHidden = true
        }
        
        let unitsArray = formulasArray[row].conversionString.components(separatedBy: " to ")
        fromUnits = unitsArray[0]
        toUnits = unitsArray[1]
        fromUnitsLabel.text = fromUnits
       // userInput.text = toUnits
        calculateConversion()
        
    }
    
    
    
}
