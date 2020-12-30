//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Ashique on 30/12/20.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    

    @IBOutlet weak var tableView: UITableView!
    
    
    //reference to managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items:[Person]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        tableView.dataSource = self
        tableView.delegate = self
        
        //Get items from CoreData
        fetchPeople()
        
        
    }
    
    func relationshipDemo()
    {
        //create a Family
        
        let family = Family(context: context)
        family.name = "Abc Family"
        
        //create a person
        
        let person = Person(context: context)
        person.name = "Maggie"
        //add to family
        family.addToPeople(person)
        //another way
        //person.family = family
        
        //save the context
        do{
            try! context.save()
        }
        catch{
            
        }
       
        
        
    }
    
    func fetchPeople()
    {
        //Fetch dat from coredata to display to tableView
        do{
            
            let request = Person.fetchRequest() as NSFetchRequest<Person>
            
            //set filtering and sorting
//            let pred = NSPredicate(format: "name CONTAINS %@","Ted")
//            request.predicate = pred
            
            //sort
            
            let sort = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sort]
            
            self.items = try! context.fetch(request)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch{
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell",for: indexPath)
        
        
        let person = self.items![indexPath.row]
        cell.textLabel?.text = person.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let person = self.items![indexPath.row]
        
            //create alert
        
        let alert = UIAlertController(title: "Edit person", message: "Edit Name", preferredStyle: .alert)
        alert.addTextField()
        let textfield = alert.textFields![0]
        textfield.text = person.name
        
        let saveButton = UIAlertAction(title: "Save", style: .default){
            (action) in
            
            //get the textfield for person object
            let textField = alert.textFields![0]
            
            //edit name
            person.name = textfield.text
            
            //save
            do{
                    try! self.context.save()
            }
            catch{
                
            }
            
            //refetch the data
            self.fetchPeople()
            

        }
        //Add alert button
        alert.addAction(saveButton)
        //present
        self.present(alert, animated: true, completion: nil)
        
            
        
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            //which person to remove
            let personToRemove = self.items![indexPath.row]
            //remove the person
            self.context.delete(personToRemove)
            //save the data
            do{
                    try! self.context.save()
            }
            catch{
                
            }
            
            //refetch the data
            self.fetchPeople()
            
            
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }

    
    @IBAction func addtapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add person", message: "Add Name", preferredStyle: .alert)
        alert.addTextField()
        
        
        let submitButton = UIAlertAction(title: "Add", style: .default){
            (action) in
            
            let textfield = alert.textFields?[0]
            
            //create peroson object
            let newPerson = Person(context: self.context)
            newPerson.name = textfield?.text
            newPerson.age = 25
            newPerson.gender = "NA"
            
            //Save tne data
            do{
               try!  self.context.save()
            }
            catch{
                
            }
           
            //referesh the view
            self.fetchPeople()
            
            
        }
        alert.addAction(submitButton)
        
        self.present(alert, animated: true, completion: nil)
    }
}

