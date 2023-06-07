//
//  ViewController.swift
//  13_01_2023_CoreDataDemo
//
//  Created by Vishal Jagtap on 07/06/23.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        create()
        retrive()
        update()
        retrive()
        delete()
        retrive()
    }
    
    func create(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let personEntity = NSEntityDescription.entity(forEntityName: "Person", in: context)
        
        for i in 1...3{
            
            let person = NSManagedObject(entity: personEntity!, insertInto: context)
            person.setValue("Person\(i)", forKey: "name")
            person.setValue("person\(i)@gmail.com", forKey: "email")
        }
        
        do{
            try context.save()
        }catch let error as NSError{
            print("Data storage failed \(error.userInfo)")
        }
    }
    
    func retrive(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        do{
            let personRecords = try context.fetch(fetchRequest)
            for eachPersonRecord in personRecords as! [NSManagedObject]{
                print(eachPersonRecord.value(forKey: "name") as! String)
                print(eachPersonRecord.value(forKey: "email") as! String)
            }
        }catch{
            print("Error in fecthing data from Person Entity")
        }
    }


    func update(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Person")
    
        fetchRequest.predicate = NSPredicate(format: "name = %@", "Person1")
        do{
            let result = try context.fetch(fetchRequest)
            let objectToBeUpdated = result[0] as! NSManagedObject
            objectToBeUpdated.setValue("Shubham", forKey: "name")
            do{
                try context.save()
            }catch{
                print(error)
            }
        }catch{
            print(error)
        }
    }
    
    func delete(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        
        fetchRequest.predicate = NSPredicate(format: "name = %@", "Person2")
        
        do{
            let result = try context.fetch(fetchRequest)
            let objectToBeDeleted = result[0] as! NSManagedObject
            context.delete(objectToBeDeleted)
            
            do{
                try context.save()
            }catch{
                print(error)
            }
        }catch{
            print(error)
        }
    }
}

