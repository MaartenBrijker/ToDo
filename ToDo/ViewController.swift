       //                                                           //
      //  ViewController.swift                                     //
     //  ToDo                                                     //
    //                                                           //
   //  Created by Maarten Brijker on 08/04/16.                  //
  //  Copyright © 2016 Maarten_Brijker. All rights reserved.   //
 //                                                           //
///////////////////////////////////////////////////////////////

import UIKit
import SQLite

class ViewController: UIViewController {
    
    // List to hold "todo's" so tableview can display them.
    var stuff = [String] ()
    
    // deleteId
    var deleteId: Int?
    
    // SQLite Database:
    var database: Connection?
    let dontforgets = Table("dontforgets")
    let id = Expression<Int>("id")          // this was first of type <Int64> ...
    let todo = Expression<String>("todo")
   
    // Outlets for tableview and type field.
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addTextField: UITextField!
    
// MARK: - Basic app life cycle things.

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
    
    func colorCells(index: Int) -> UIColor {
        let itemCount = stuff.count - 1
        let degradingValue = (CGFloat(index) / CGFloat(itemCount)) * 0.8
        return UIColor(red: 0.7, green: 0.4, blue: degradingValue, alpha: 0.2)
    }
    
// MARK: - Adding to and setting up the database.
    
    // INSERT INTO "dontforgets" ("todo") VALUES ('buy groceries').
    @IBAction func addButton(sender: AnyObject) {
        
        let someToDo = addTextField.text!
        
        do {
            if someToDo != "" {
                let insert = dontforgets.insert(todo <- someToDo)
                let rowId = try database!.run(insert)
                
                // Update To Do list to be displayed.
                displayToDoList()
                
                // Clear textfield after submitting.
                addTextField.text = ""
            }
        }
        catch {
            // Error handling here.
            print("Error creating todo: \(error)")
        }
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
                t.column(id, primaryKey: .Autoincrement)                     // "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL.
                t.column(todo, unique: true)                                 // "todo" TEXT UNIQUE NOT NULL.
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
    
    /// delete later ///
    func printfunction() {
        print("workx5")
    }
    
// MARK: - Deleting row from the database.
    
    func deleteRowFromDatabase() {
        
        let toDelete = dontforgets.filter(id == deleteId!)
//        let toDelete = dontforgets
        
        print(toDelete)
        
        do {
            // DELETE FROM "users" WHERE ("id" = 1)
            if try database!.run(toDelete.delete()) > 0 {
                print("deleted!")
            }
            displayToDoList()
        }
        catch {
            // Error handling here.
            print("wasnt able to delete row as: \(error)")
        }
    }
    
}

// MARK: - the UITableview.
       
extension ViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stuff.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomCell
        cell.toDoLabel.text = self.stuff[indexPath.row]
        
        // Delete selection style.
        cell.selectionStyle = .None
        
        return cell
    }
    
    // Set color of rows.
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = colorCells(indexPath.row)
    }
    
    // Delete rows
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

        // Remove the row from data model
//        if editingStyle == UITableViewCellEditingStyle.Delete {
//            stuff.removeAtIndex(indexPath.row)
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
//        }

        // Get row number.
        deleteId = indexPath.row
        
        deleteRowFromDatabase()
    }
    

}
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       