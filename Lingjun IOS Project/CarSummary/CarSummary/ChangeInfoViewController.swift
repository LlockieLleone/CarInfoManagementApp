//
//  ChangeInfoViewController.swift
//  CarSummary
//
//  Created by english on 2020-12-06.
//  Copyright © 2020 IOSDevelopCourse. All rights reserved.
//

import UIKit
import CoreData

class ChangeInfoViewController: UIViewController {
    
    var choosenCarName = ""
    var choosenCarId : UUID?

    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtBrand: UITextField!
    
    @IBOutlet weak var txtEngineType: UITextField!
    
    @IBOutlet weak var txtTransmission: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnSave.layer.cornerRadius = 20
        btnSave.layer.shadowOpacity = 0.8
        btnSave.layer.shadowColor = UIColor.black.cgColor
        btnSave.layer.shadowOffset = CGSize(width: 3, height: 3)
        
        getDataById()
    }
    
    @IBAction func btnSavePressed(_ sender: UIButton) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newCar = NSEntityDescription.insertNewObject(forEntityName: "Cars", into: context)
        
        newCar.setValue(txtName.text!, forKey: "name")
        newCar.setValue(txtBrand.text!, forKey: "brand")
        newCar.setValue(txtEngineType.text!, forKey: "engine")
        newCar.setValue(txtTransmission.text!, forKey: "transmission")
        newCar.setValue(UUID(), forKey: "id")
        
        do{
            try context.save()
            print("Information saved successfully")
        }catch{
            print("Error on save information")
        }
        
        navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name("NewCar"), object: nil)
    }
    
    func getDataById(){
        
        if choosenCarName != ""{
            
            let idString = choosenCarId?.uuidString
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cars")
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
            fetchRequest.returnsObjectsAsFaults = false
            
            
            do{
                let results = try context.fetch(fetchRequest)
                
                if results.count > 0{
                    for result in results as! [NSManagedObject]{
                        if let name = result.value(forKey: "name") as? String{
                            txtName.text = name
                        }
                        if let brand = result.value(forKey: "brand") as? String{
                            txtBrand.text = brand
                        }
                        if let engine = result.value(forKey: "engine") as? String{
                            txtEngineType.text = engine
                        }
                        if let transmission = result.value(forKey: "transmission") as? String{
                            txtTransmission.text = transmission
                        }
                        
                    }
                }
            }catch{
                print("Error when fetching data from database model")
            }
        }
    }

}
