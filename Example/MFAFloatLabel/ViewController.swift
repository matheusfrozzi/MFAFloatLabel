//
//  ViewController.swift
//  MFAFloatLabel
//
//  Created by matheusfrozzi on 04/16/2019.
//  Copyright (c) 2019 matheusfrozzi. All rights reserved.
//

import UIKit
import MFAFloatLabel

class ViewController: UIViewController {

    @IBOutlet weak var textFieldPhoneNumber: MFAFloatLabel!
    @IBOutlet weak var textFieldUsername: MFAFloatLabel!

    private let correctUserName = "matheusfrozzi"

    override func viewDidLoad() {
        super.viewDidLoad()

        textFieldPhoneNumber.setFormatting("(__) _____.____", replacementChar: "_")
    }
}

extension ViewController: MFAFloatLabelDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
        case textFieldUsername:
            if textField.text == correctUserName {
                textFieldUsername.borderColor = .green
                textFieldUsername.icon = #imageLiteral(resourceName: "icon-check")
            } else {
                textFieldUsername.borderColor = .red
                textFieldUsername.icon = #imageLiteral(resourceName: "icon-check-disable")
            }
        default:
            break
        }
    }
}

