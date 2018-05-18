//
//  dateCreatedViewController.swift
//  Home-Owner
//
//  Created by Vo Huy on 5/16/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit

class DateCreatedViewController: UIViewController {
    
    var item: Item!
    var datePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Created Date"
        
        // Create a datePicker dialog
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.date = item.dateCreated
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(datePicker)
        
        // add constraints
        datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        datePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // set item's date to the chosen date
        item.dateCreated = datePicker.date
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
