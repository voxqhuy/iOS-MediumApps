//
//  customTextField.swift
//  Home-Owner
//
//  Created by Vo Huy on 5/16/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit

class customTextField: UITextField {
    
    override func becomeFirstResponder() -> Bool {
        borderStyle = .line
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        borderStyle = .roundedRect
        return super.resignFirstResponder()
    }
}
