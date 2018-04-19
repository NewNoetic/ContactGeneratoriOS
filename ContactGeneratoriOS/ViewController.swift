//
//  ViewController.swift
//  ContactGeneratoriOS
//
//  Created by Sidhant Gandhi on 4/19/18.
//  Copyright © 2018 NewNoetic, Inc. All rights reserved.
//

import UIKit
import ContactGenerator
import PromiseKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func addTapped(_ sender: Any) {
        ContactGenerator.generate()
            .done { (contacts) in
                ContactGenerator.saveToDevice(contacts)
                self.showOkayAlert(title: "Saved", message: contacts.reduce("", { (r, c) -> String in
                    var new = r
                    new.append("\(c.firstName, c.lastName, c.email, c.phone)\n")
                    return new
                }))
            }.catch { (error) in
                self.showOkayAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
    @IBAction func deleteAllTapped(_ sender: Any) {
        ContactGenerator.deleteAllContacts()
    }
    
    func showOkayAlert(title: String?, message: String?, completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: completion))
        self.present(alert, animated: true)
    }
}

