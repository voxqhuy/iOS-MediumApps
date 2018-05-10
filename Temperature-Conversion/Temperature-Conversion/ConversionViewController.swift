//
//  ConversionViewController.swift
//  Temperature-Conversion
//
//  Created by Vo Huy on 5/9/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    @IBOutlet var celsiusLabel: UILabel!
    @IBOutlet var userInputField: UITextField!
    var fahrenheitValue: Measurement<UnitTemperature>? {
        didSet {
            updateCelsiusLabel()
        }
    }
    var celsiusValue: Measurement<UnitTemperature>? {
        if let fahrenheitValue = fahrenheitValue {
            return fahrenheitValue.converted(to: .celsius)
        } else {
            return nil
        }
    }
    // format value up to one fractional digit
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    // time for noon
//    let noon = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!
    
    // built-in functions
    override func viewWillAppear(_ animated: Bool) {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        if hour >= 17 || hour <= 6 {
            view.backgroundColor = UIColor.darkGray
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateCelsiusLabel()
        print("running conversion")
    }
    
    // MARK: UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        // decimal separator is different from region to region
        let currentLocale = Locale.current
        let decimalSeparator = currentLocale.decimalSeparator ?? "."
        
        let existingTextHasDecimalSeparator = textField.text?.range(of: decimalSeparator)
        let replacementTextHasDecimalSeparator = string.range(of: decimalSeparator)
        
        if (string.rangeOfCharacter(from: NSCharacterSet.letters) != nil) {
            return false
        }
        
        if existingTextHasDecimalSeparator != nil, replacementTextHasDecimalSeparator != nil {  // if both have the decimal separator
            return false
        } else {
            return true
        }
    }
    
    // MARK: Actions
    @IBAction func fahrenheitFieldEditingChanged(_ textField: UITextField) {
        // use number formatter to convert string because it's aware of the locale
        if let text = textField.text, let number = numberFormatter.number(from: text) {
            fahrenheitValue = Measurement(value: number.doubleValue, unit: .fahrenheit)
        } else {
            fahrenheitValue = nil
        }
    }

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        userInputField.resignFirstResponder()
    }
    
    // MARK: Private Methods
    func updateCelsiusLabel() {
        if let celsiusValue = celsiusValue {
            celsiusLabel.text = numberFormatter.string(from: NSNumber(value: celsiusValue.value))
        } else {
            celsiusLabel.text = "???"
        }
    }
}
