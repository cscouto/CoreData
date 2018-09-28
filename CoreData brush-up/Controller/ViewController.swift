//
//  ViewController.swift
//  CoreData brush-up
//
//  Created by Tiago Do Couto on 9/28/18.
//  Copyright © 2018 Couto Code. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Vars
    var people: [NSManagedObject] = []
    
    //MARK: - System functions
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "The List"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        do {
            people = try context.fetch(fetchRequest)
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    //MARK: - Actions
    @IBAction func addName(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Name",
                                      message: "Add a new name",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else {
                    return
            }
            self.save(name: nameToSave)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    //MARK: - Custom functions
    private func save(name: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: context)
        let person = NSManagedObject(entity: entity!, insertInto: context)
        person.setValue(name, forKey: "name")
        do {
            try context.save()
            people.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

//MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let person = people[indexPath.row]
        cell.textLabel?.text = person.value(forKey: "name") as? String
        return cell
    }
}

