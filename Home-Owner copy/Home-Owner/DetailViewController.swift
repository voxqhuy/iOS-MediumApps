 //
//  DetailViewController.swift
//  Home-Owner
//
//  Created by Vo Huy on 5/14/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit
 
 class DetailViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var serialField: UITextField!
    @IBOutlet weak var valueField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: Properties
    var item: Item! {
        didSet {
            navigationItem.title = item.name
        }
    }
    
    // formatter for money
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    // formatter for date
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    // lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        
        // display the item's info
        nameField.text = item.name
        serialField.text = item.serialNumber
        valueField.text = numberFormatter.string(from: NSNumber(value: item.valueInDollars))
        dateLabel.text = dateFormatter.string(from: item.dateCreated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // clear first responder
        view.endEditing(true)
        
        // Save changes to the item
        item.name = nameField.text ?? ""
        item.serialNumber = serialField.text
        if let valueText = valueField.text,
            let value = numberFormatter.number(from: valueText) {
            item.valueInDollars = value.intValue
        } else {
            item.valueInDollars = 0
        }
    }
    
    // MARK: Delegation
    
    // when the user is entering input
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == valueField {
            
            // decimal separator of the region
        }
        return true
    }
    // when the Return button is pressed on a text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Actions
    @IBAction func backgroundTapped(_ sender: Any) {
        // clear first responder when the users tap on the screen
        view.endEditing(true)
    }
    
 }
