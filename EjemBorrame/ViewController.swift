//
//  ViewController.swift
//  EjemBorrame
//
//  Created by Raymundo Peralta on 1/14/17.
//  Copyright © 2017 Industrias Peta. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var people = [NSManagedObject]()
    
    var edad: Int = 10
    
    @IBAction func addName(sender: AnyObject) {
        let alert = UIAlertController(title: "New Name",
                                      message: "Add a new name",
                                      preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .Default,
                                       handler: { (action:UIAlertAction) -> Void in
                                        
                                        let textField = alert.textFields!.first
                                        self.saveName(textField!.text!)
                                        self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
                              animated: true,
                              completion: nil)
    }
    
    @IBAction func prueba(sender: AnyObject) {
        print("pasamos por boton prueba")
        
        //let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = CoreDataStack.sharedInstance.managedObjectContext
        //let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: managedContext)
        
        print("\(people[0].valueForKey("name")!)")
        print("\(people[0].valueForKey("edad")!)")
            
        people[0].setValue((people[0].valueForKey("edad") as! Int) + 1, forKey: "edad")
        people[1].setValue((people[1].valueForKey("edad") as! Int) + 1, forKey: "edad")
        
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("No pudimos salvar \(error), \(error.userInfo)")
        }
        managedContext.deleteObject(people[2])
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("No pudimos salvar \(error), \(error.userInfo)")
        }
        
        let fetchRequest = NSFetchRequest(entityName: "Person")
        
        //3
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            people = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func saveName(name: String) {
        print("Pasamos por save")
        //let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = CoreDataStack.sharedInstance.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: managedContext)
        
        let person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        person.setValue(name, forKey: "name")
        person.setValue(self.edad++, forKey: "edad")
        do {
            try managedContext.save()
            
            people.append(person)
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\"The List\""
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        //let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = CoreDataStack.sharedInstance.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Person")
        
        //3
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            people = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(tableView: UITableView,
                   cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCellWithIdentifier("Cell")
        
        let person = people[indexPath.row]
        print("\(indexPath.row)")
        print("\(person.valueForKey("name")!)-\(person.valueForKey("edad")!)")
        
        cell!.textLabel!.text = (person.valueForKey("name") as! String) + "-\(person.valueForKey("edad")!)"
        
        return cell!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

