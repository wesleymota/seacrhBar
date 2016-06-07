//
//  HomeTableViewController.swift
//  
//
//  Created by Wesley Mota on 06/06/16.
//
//

import UIKit
import Firebase

class HomeTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {

    var ref = FIRDatabase.database().reference()
    
    var nome: String!
    var items = [GroceryItem]()
    var sobrenome: String!
    var filteredNames = [GroceryItem]()
    
    
    var detailViewController: DetailViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        ref.child("Cadastro").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            var newItems = [GroceryItem]()
            
            for item in snapshot.children {
                
                let groceryItem = GroceryItem(snapshot: item as! FIRDataSnapshot)
                newItems.append(groceryItem)
            }
            
            self.items = newItems
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return items.count
        
        if (tableView == self.searchDisplayController?.searchResultsTableView){
            return self.filteredNames.count
        } else{
            return items.count
        }
        
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomTableViewCell
        
        let groceryItem = items[indexPath.row]
        var items1: GroceryItem
        
        cell.nameLbl.text = groceryItem.nome
        cell.lastNameLbl.text = groceryItem.sobrenome

        
        if (tableView == self.searchDisplayController?.searchResultsTableView) {
            items1 = self.filteredNames[indexPath.row]
        } else {
            items1 = self.items[indexPath.row]
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var items1: GroceryItem
        if (tableView == self.searchDisplayController?.searchResultsTableView) {
            items1 = self.filteredNames[indexPath.row]
        } else {
            items1 = self.items[indexPath.row]
        }
        
        print(items1.nome)
        
    }
    
    func filterContetnForSearchText(searchText: String, scope: String = "All") {
    
        self.filteredNames = self.items.filter({ (friend: GroceryItem) -> Bool in
            var categoryMatch = (scope == "All")
            var stringMatch = friend.nome.rangeOfString(searchText)
            
            return categoryMatch && (stringMatch != nil)
        })
        
        
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool
        
    {
        self.filterContetnForSearchText(searchString!, scope: "All")
        return true
        
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool
        
    {
        
        self.filterContetnForSearchText(self.searchDisplayController!.searchBar.text!, scope: "All")
        return true
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
