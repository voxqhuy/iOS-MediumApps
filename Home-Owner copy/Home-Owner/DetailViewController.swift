 //
//  DetailViewController.swift
//  Home-Owner
//
//  Created by Vo Huy on 5/14/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit
 
 class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var nameField: customTextField!
    @IBOutlet weak var serialField: customTextField!
    @IBOutlet weak var valueField: customTextField!
    @IBOutlet weak var dateLabel: customTextField!
    @IBOutlet var  imageView: UIImageView!
    @IBOutlet var removeImgBtn: UIButton!
    
    // MARK: - Properties
    var item: Item! {
        didSet {
            navigationItem.title = item.name
        }
    }
    
    var imageStore: ImageStore!
    
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
    
    // MARK: - View life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        
        // display the item's info
        nameField.text = item.name
        serialField.text = item.serialNumber
        valueField.text = numberFormatter.string(from: NSNumber(value: item.valueInDollars))
        dateLabel.text = dateFormatter.string(from: item.dateCreated)
        
        // Get the item key
        let key = item.itemKey
        
        // If there is an associated image with the item, display it
        if let image = imageStore.image(forKey: key) {
            imageView.image = image
            removeImgBtn.isEnabled = true
        } else {
            removeImgBtn.isEnabled = false
        }
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
            item.valueInDollars = value.doubleValue
        } else {
            item.valueInDollars = 0
        }
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "changeDate":
            let dateCreatedViewController = segue.destination as! DateCreatedViewController
            dateCreatedViewController.item = item
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    
    // MARK: - Delegation
    
    // when the user is entering input
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == valueField {
            
            // avoid enter text in money value
            if string.rangeOfCharacter(from: NSCharacterSet.letters) != nil {
                return false
            }
            
            // decimal separator of the region
            let currentLocale = Locale.current
            let decimalSeparator = currentLocale.decimalSeparator ?? "."
            
            let existingTextHasDecimalSeparator = textField.text?.range(of: decimalSeparator)
            let replacementTextDecimalSeparator = string.range(of: decimalSeparator)
            
            if existingTextHasDecimalSeparator != nil, replacementTextDecimalSeparator != nil {
                return false
            } else {
                return true
            }
        }
        return true
    }
    // when the Return button is pressed on a text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // after the user took a picture or chose an image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // Get picked image from info dictionary
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Store the image in the ImageStore for the item's key
        imageStore.setImage(image, forKey: item.itemKey)
        
        // Put the image on the screen in the image view
        imageView.image = image
        
        // Take image picker off the screen
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Actions
    @IBAction func backgroundTapped(_ sender: Any) {
        // clear first responder when the users tap on the screen
        view.endEditing(true)
    }
    
    @IBAction func takePicture(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        
        // set up the image picker
        // if the device has a camera, take a picture; otherwise, choose one from the library
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            
            // creating a crosshair
            let overlayView = UIView(frame: imagePicker.cameraOverlayView!.frame)
            
            let crosshairLabel = UILabel()
            crosshairLabel.text = "+"
            crosshairLabel.font = UIFont.systemFont(ofSize: 50)
            crosshairLabel.translatesAutoresizingMaskIntoConstraints = false
            overlayView.addSubview(crosshairLabel)
            // place the crosshair in the middle
            crosshairLabel.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor)
            crosshairLabel.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor)
            
            // To avoid blocking the underneath default camera controls
            overlayView.isUserInteractionEnabled = false
            
            imagePicker.cameraOverlayView = overlayView
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        // Display the image picker on the screen modally
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func removeImage(_ sender: UIButton) {
        imageStore.deleteImage(forKey: item.itemKey)
        imageView.image = nil
        removeImgBtn.isEnabled = false
    }
    
 }
