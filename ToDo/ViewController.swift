//
//  ViewController.swift
//  ToDo
//
//  Created by Maarten Brijker on 08/04/16.
//  Copyright © 2016 Maarten_Brijker. All rights reserved.
//
///////////////////////////////////////////////////////////////

import UIKit
import SQLite

class ViewController: UIViewController {
    
    var stuff = [String] ()
    
    // SQLite Database:
    var database: Connection?
    let dontforgets = Table("dontforgets")
    let id = Expression<Int64>("id")
    let todo = Expression<String>("todo")
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addTextField: UITextField!

    // INSERT INTO "dontforgets" ("todo") VALUES ('buy groceries').
    @IBAction func addButton(sender: AnyObject) {
       
        let someToDo = addTextField.text!
        
        do {
            if someToDo != "" {
                let insert = dontforgets.insert(todo <- someToDo)
                let rowId = try database!.run(insert)
                // Update To Do list to be displayed.
                displayToDoList()
            }
        }
        catch {
            // Error handling here.
            print("Error creating todo: \(error)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup database.
        setupDatabase()
        displayToDoList()
        tableView.reloadData()
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
            try database!.run(dontforgets.create(ifNotExists: true) { t in   // CREATE TABLE: "dontforgets"
                t.column(id, primaryKey: .Autoincrement)                    // "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
                t.column(todo, unique: true)                                // "todo" TEXT UNIQUE NOT NULL,
            })
        }
        catch {
            // Error handling here.
            print("Failed to create table: \(error)")
        }
    }
    
    // Loops over the database, puts all in a string so table can display them.
    private func displayToDoList() {

        do {
            stuff = []
            for dontforget in try database!.prepare(dontforgets.select(todo)) {
                let todoValue = dontforget[todo]
                stuff.append(todoValue)
            }
            //print(stuff)
            tableView.reloadData()
        }
        catch {
            // Error handling here.
            print("Failed to find todo: \(error)")
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

