//
//  CarListViewController.swift
//  CarSummary
//
//  Created by english on 2020-12-06.
//  Copyright © 2020 IOSDevelopCourse. All rights reserved.
//

import UIKit
import CoreData

class CarTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var nameArray = [String]()
    var idArray = [UUID]()
    
    var selectedCarName = ""
    var selectedCarId : UUID?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let  cell = UITableViewCell()
        cell.textLabel?.text = nameArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedCarName = nameArray[indexPath.row]
        selectedCarId = idArray[indexPath.row]
        
        performSegue(withIdentifier: "CarDetailSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CarDetailSegue"{
            let passingData = segue.destination as! ChangeInfoViewController
            passingData.choosenCarName = selectedCarName
            passingData.choosenCarId = selectedCarId
        }
    }
    
    @IBOutlet weak var CarTableView: UITableView!
    
    @IBOutlet weak var btnAdd: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnAdd.layer.cornerRadius = 20
        btnAdd.layer.shadowOpacity = 0.8
        btnAdd.layer.shadowColor = UIColor.black.cgColor
        btnAdd.layer.shadowOffset = CGSize(width: 3, height: 3)
        
        CarTableView.delegate = self
        CarTableView.dataSource = self

        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: Notification.Name("NewCar"), object: nil)
    }
    
    
    @IBAction func btnAddPressed(_ sender: UIButton) {
        
        selectedCarName = ""
        
        performSegue(withIdentifier: "CarDetailSegue", sender: nil)
    }
    
    @objc func getData(){
        
        nameArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cars")
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            let results = try context.fetch(fetchRequest)
            
            if results.count > 0{
                for result in results as! [NSManagedObject]{
                    if let name = result.value(forKey: "name") as? String{
                        self.nameArray.append(name)
                    }
                    if let id = result.value(forKey: "id") as? UUID{
                        self.idArray.append(id)
                    }
                    
                    CarTableView.reloadData()
                    
                }
            }
        }catch{
            print("Error when fetching data from database model")
        }
    }
}
