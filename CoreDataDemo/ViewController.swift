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
        
        let pC = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //Get items from CoreData
        fetchPeople()
        
        
    }
    
    func fetchPeople()
    {
        //Fetch dat from coredata to display to tableView
        do{
            self.items = try! context.fetch(Person.fetchRequest())
            
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

