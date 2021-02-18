//
//  RegistrationViewController.swift
//  CarSummary
//
//  Created by english on 2020-12-06.
//  Copyright © 2020 IOSDevelopCourse. All rights reserved.
//

import UIKit
import CoreData

class RegistrationViewController: UIViewController {

    @IBOutlet weak var btnRegister: UIButton!
    
    @IBOutlet weak var txtRusername: UITextField!
    
    @IBOutlet weak var txtRpassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnRegister.layer.cornerRadius = 25
        btnRegister.layer.shadowOpacity = 0.8
        btnRegister.layer.shadowColor = UIColor.black.cgColor
        btnRegister.layer.shadowOffset = CGSize(width: 3, height: 3)

    }
    
    @IBAction func btnRegisterPressed(_ sender: UIButton) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
        
        newUser.setValue(txtRusername.text!, forKey: "username")
        newUser.setValue(txtRpassword.text!, forKey: "password")
        newUser.setValue(UUID(), forKey: "id")
        
        do{
            try context.save()
            print("Information saved successfully")
        }catch{
            print("Error on save information")
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    

}
