//
//  ViewController.swift
//  CarSummary
//
//  Created by english on 2020-12-05.
//  Copyright © 2020 IOSDevelopCourse. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    
    @IBOutlet weak var txtUsername: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBAction func btnLoginPressed(_ sender: UIButton) {
        if userValidation(){
            performSegue(withIdentifier: "CarTableViewSegue", sender: nil)
        }else{
            let alert = UIAlertController(title: "Login fail", message: "Incorrect Password or Username", preferredStyle:  .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) {
                (UIAlertAction) in
            }
            
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBAction func btnRegistration(_ sender: UIButton) {
        performSegue(withIdentifier: "RegistrationSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnLogin.layer.cornerRadius = 20
        btnLogin.layer.shadowOpacity = 0.8
        btnLogin.layer.shadowColor = UIColor.black.cgColor
        btnLogin.layer.shadowOffset = CGSize(width: 3, height: 3)
        
        
    }
    
    func userValidation() -> Bool{
        
        var validation : Bool = true
        
        let usernameString = txtUsername.text
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        fetchRequest.predicate = NSPredicate(format: "username == %@ ",usernameString!)
        fetchRequest.returnsObjectsAsFaults = false
        
        
        do{
            let results = try context.fetch(fetchRequest)
            
            if results.count > 0{
                for result in results as! [NSManagedObject]{
                    if let password = result.value(forKey: "password") as? String{
                        if txtPassword.text! == password{
                            validation = true
                        }else{
                            validation = false
                        }
                    }
                    
                }
            }
        }catch{
            print("Error when fetching data from database model")
            validation = false
        }
        

        if validation{
            return true
        }else{
            return false
        }
    }
}

