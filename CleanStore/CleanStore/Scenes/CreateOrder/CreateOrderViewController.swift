//
//  CreateOrderViewController.swift
//  CleanStore
//
//  Created by Vo Huy on 1/3/19.
//  Copyright © 2019 Vo Huy. All rights reserved.
//

import UIKit

protocol CreateOrderDisplayLogic: class
{
    func displaySomething(viewModel: CreateOrder.Something.ViewModel)
}

class CreateOrderViewController: UITableViewController, CreateOrderDisplayLogic
{
    
    var interactor: CreateOrderBusinessLogic?
    var router: (NSObjectProtocol & CreateOrderRoutingLogic & CreateOrderDataPassing)?
    
    // MARK: -- Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: -- Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = CreateOrderInteractor()
        let presenter = CreateOrderPresenter()
        let router = CreateOrderRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: -- Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: -- View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        for textField in textFields {
            textField.delegate = self
        }
        shippingMethodPicker.delegate = self
        shippingMethodPicker.dataSource = self
        
        configurePickers()
    }
    
    // MARK: -- Layout
    func configurePickers()
    {
        shippingMethodTextFeld.inputView = shippingMethodPicker
    }
        
    // MARK: -- Outlets
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var shippingMethodTextFeld: UITextField!
    @IBOutlet weak var expirationDateTextField: UITextField!
    @IBOutlet weak var shippingMethodPicker: UIPickerView!
    @IBOutlet weak var expirationDatePicker: UIDatePicker!
    
    // MARK: -- User Interaction
    @IBAction func expirationDatePickerValueChanged(_ sender: UIDatePicker) {
    }
    
    // MARK: -- TableView functions
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            for textField in textFields {
                // show keybaord when the user taps on the row
                if textField.isDescendant(of: cell) {
                    textField.becomeFirstResponder()
                }
            }
        }
    }
    
    
    // MARK: -- Additional Helpers
    func doSomething()
    {
//        let request = CreateOrder.Something.Request()
//        interactor?.doSomething(request: request)
    }
    
    func displaySomething(viewModel: CreateOrder.Something.ViewModel)
    {
        //nameTextField.text = viewModel.name
    }
}

// MARK: @protocol UITextFieldDelegate
extension CreateOrderViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        if let index = textFields.firstIndex(of: textField) {
            if index < textFields.count - 1 {
                let nextTextField = textFields[index]
                nextTextField.becomeFirstResponder()
            }
        }
        return true
    }
}

// MARK: @protocol UIPickerViewDelegate, UIPickerViewDataSource
extension CreateOrderViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // number of columns
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return interactor?.shippingMethods.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return interactor?.shippingMethods[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        shippingMethodTextFeld.text = interactor?.shippingMethods[row0]
    }
    
    
}
