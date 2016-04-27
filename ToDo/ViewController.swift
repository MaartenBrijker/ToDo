//
//  ViewController.swift
//  ToDo
//
//  Created by Maarten Brijker on 08/04/16.
//  Copyright © 2016 Maarten_Brijker. All rights reserved.
//

import UIKit
import SQLite

class ViewController: UIViewController {
    
    var stuff = [String] ()
    var newToDo = ""
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addTextField: UITextField!

    // Add todo to database
    @IBAction func addButton(sender: AnyObject) {
       
        // add new 'to do' text
        newToDo = addTextField.text!
        stuff.append(newToDo)
        self.tableView.reloadData()
        
        print(stuff)
        
    }
    
    // SQLite Database:
    var database: Connection?
    
    let users = Table("users")
    let id = Expression<Int64>("id")
    let todo = Expression<String>("name")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup database
        setupDatabase()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupDatabase() {
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        
        do {
            // If connection is set up, create table.
            database = try Connection("\(path)/db.sqlite3")
            createTable()
        }
            
        catch {
            // Error handling here.
            print("Cannot connect to database: \(error)")
            
        }
    }
    
    private func createTable(){
        
        do {
            try database!.run(users.create(ifNotExists: true) { t in    // CREATE TABLE: "users"
            
                t.column(id, primaryKey: .Autoincrement)            // "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
                t.column(todo, unique: true)                        // "mail" TEXT UNIQUE NOT NULL,
            })
        }
            
        catch {
            // Error handling here.
            print("Failed to create table: \(error)")
        }
    }
    
    
}
    
extension ViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stuff.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomCell
        
        cell.toDoLabel.text = self.stuff[indexPath.row]
        
        return cell
        
    }
}

extension ViewController: UITableViewDelegate {
    
}

